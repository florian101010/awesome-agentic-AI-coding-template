#!/usr/bin/env bash
# setup.sh
#
# Interactive first-time setup for awesome-agentic-AI-coding-template.
# Populates the most common [FILL:] markers across all agent instruction files
# and optionally activates git hooks.
#
# Usage:
#   bash setup.sh
#
# Run once after cloning, before your first AI agent session.
# Safe to re-run — only replaces markers that are still present.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Colours ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

hr()  { echo -e "${CYAN}$(printf '─%.0s' {1..60})${RESET}"; }
ok()  { echo -e "  ${GREEN}✓${RESET} $*"; }
skip(){ echo -e "  ${YELLOW}–${RESET} $*"; }

# ─── Input helpers ───────────────────────────────────────────────────────────

# ask <var_name> <prompt> [default]  — required field
ask() {
  local __var="$1" prompt="$2" default="${3:-}" value
  echo -e "\n${BOLD}${prompt}${RESET}"
  [[ -n "$default" ]] && echo -e "  ${YELLOW}Default: ${default}${RESET}"
  while true; do
    read -rp "  > " value
    [[ -z "$value" && -n "$default" ]] && value="$default"
    [[ -n "$value" ]] && break
    echo -e "${RED}  Required — please enter a value.${RESET}"
  done
  printf -v "$__var" '%s' "$value"
}

# ask_opt <var_name> <prompt>  — optional field (Enter to skip)
ask_opt() {
  local __var="$1" prompt="$2" value
  echo -e "\n${BOLD}${prompt}${RESET}"
  echo -e "  ${YELLOW}(press Enter to skip)${RESET}"
  read -rp "  > " value
  printf -v "$__var" '%s' "$value"
}

# ─── Replacement engine ──────────────────────────────────────────────────────

# replace_literal <relative_file> <old_string> <new_string>
# Performs an exact literal string replacement using Python (handles special
# chars and multi-line strings reliably across GNU/macOS environments).
replace_literal() {
  local file="${REPO_ROOT}/$1" old="$2" new="$3"
  [[ -f "$file" ]] || return 0
  python3 - "$file" "$old" "$new" <<'PYEOF'
import sys
path, old, new = sys.argv[1], sys.argv[2], sys.argv[3]
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()
updated = content.replace(old, new)
if updated != content:
    with open(path, 'w', encoding='utf-8') as f:
        f.write(updated)
PYEOF
}

# count_fill <relative_file>  — count remaining [FILL:] markers
count_fill() {
  grep -c '\[FILL:' "${REPO_ROOT}/$1" 2>/dev/null || true
}

# ─── Banner ──────────────────────────────────────────────────────────────────
clear
hr
echo -e "${BOLD}  Awesome Agentic AI Coding Template — Setup${RESET}"
echo -e "  Populates [FILL:] markers across all agent instruction files."
hr
echo ""
echo "  You will be asked for your project's key details."
echo "  Answers are written into:"
echo "    CLAUDE.md · AGENTS.md · GEMINI.md · .github/copilot-instructions.md"
echo ""
echo -e "  ${YELLOW}Complex sections (file structure, immutable contract, project-specific${RESET}"
echo -e "  ${YELLOW}doc links) are left as [FILL:] for you to complete manually.${RESET}"
echo ""
hr

# ─── Collect inputs ──────────────────────────────────────────────────────────

ask PROJECT_NAME "Project name (short, e.g. \"MyApp\"):"
ask DESCRIPTION  "One-sentence description of what this project does:"
ask TECH_STACK   "Tech stack (e.g. \"TypeScript, React, Node.js\"):"

echo -e "\n${BOLD}--- Commands ---${RESET}"
ask     TEST_CMD  "Test command (e.g. npm test / pytest / cargo test):"
ask_opt LINT_CMD  "Lint command (e.g. npm run lint)  [optional]:"
ask_opt BUILD_CMD "Build command (e.g. npm run build)  [optional]:"

echo -e "\n${BOLD}--- Constraints  (things agents must always respect) ---${RESET}"
echo -e "  ${YELLOW}Example: \"No runtime dependencies — only stdlib\"${RESET}"
ask     CONSTRAINT_1 "Constraint 1:"
ask_opt CONSTRAINT_2 "Constraint 2  [optional]:"

echo -e "\n${BOLD}--- Prohibitions  (things agents must never do) ---${RESET}"
echo -e "  ${YELLOW}Example: \"Commit directly to main without a PR\"${RESET}"
ask     PROHIBITION_1 "Prohibition 1:"
ask_opt PROHIBITION_2 "Prohibition 2  [optional]:"

# ─── Confirm ─────────────────────────────────────────────────────────────────
echo ""
hr
echo -e "${BOLD}  Summary:${RESET}"
echo -e "  Project       : ${GREEN}${PROJECT_NAME}${RESET}"
echo -e "  Description   : ${GREEN}${DESCRIPTION}${RESET}"
echo -e "  Tech stack    : ${GREEN}${TECH_STACK}${RESET}"
echo -e "  Test cmd      : ${GREEN}${TEST_CMD}${RESET}"
[[ -n "${LINT_CMD:-}"  ]] && echo -e "  Lint cmd      : ${GREEN}${LINT_CMD}${RESET}"
[[ -n "${BUILD_CMD:-}" ]] && echo -e "  Build cmd     : ${GREEN}${BUILD_CMD}${RESET}"
echo -e "  Constraint 1  : ${GREEN}${CONSTRAINT_1}${RESET}"
[[ -n "${CONSTRAINT_2:-}"  ]] && echo -e "  Constraint 2  : ${GREEN}${CONSTRAINT_2}${RESET}"
echo -e "  Prohibition 1 : ${GREEN}${PROHIBITION_1}${RESET}"
[[ -n "${PROHIBITION_2:-}" ]] && echo -e "  Prohibition 2 : ${GREEN}${PROHIBITION_2}${RESET}"
echo ""
read -rp "  Write these into your agent files? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# ─── Build derived values ────────────────────────────────────────────────────

# Scripts block for CLAUDE.md / GEMINI.md Available Scripts section
SCRIPTS_BLOCK="- Test: \`${TEST_CMD}\`"
[[ -n "${LINT_CMD:-}"  ]] && SCRIPTS_BLOCK="${SCRIPTS_BLOCK}
- Lint: \`${LINT_CMD}\`"
[[ -n "${BUILD_CMD:-}" ]] && SCRIPTS_BLOCK="${SCRIPTS_BLOCK}
- Build: \`${BUILD_CMD}\`"

echo ""
hr
echo -e "${BOLD}  Writing files...${RESET}"
echo ""

# ─── CLAUDE.md ───────────────────────────────────────────────────────────────
F="CLAUDE.md"

replace_literal "$F" \
  '[FILL: Project name] — [FILL: 1-sentence description]. [FILL: Tech stack, e.g. "TypeScript, React, Node.js"].' \
  "${PROJECT_NAME} — ${DESCRIPTION}. ${TECH_STACK}."

replace_literal "$F" \
  '[FILL: Constraint 1 — e.g. "No runtime dependencies — only stdlib"]' \
  "${CONSTRAINT_1}"

if [[ -n "${CONSTRAINT_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Constraint 2 — e.g. "All API calls must go through the gateway module"]' \
    "${CONSTRAINT_2}"
fi

replace_literal "$F" \
  '[FILL: Prohibition 1 — e.g. "Use localStorage or sessionStorage"]' \
  "${PROHIBITION_1}"

if [[ -n "${PROHIBITION_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Prohibition 2 — e.g. "Commit directly to main without a PR"]' \
    "${PROHIBITION_2}"
fi

replace_literal "$F" \
  '[FILL: List your key build/test/lint commands here, e.g.:

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

]' \
  "${SCRIPTS_BLOCK}"

replace_literal "$F" \
  '[FILL: test command, e.g. npm test]' \
  "${TEST_CMD}"

ok "$F"

# ─── GEMINI.md ───────────────────────────────────────────────────────────────
F="GEMINI.md"

replace_literal "$F" \
  '[FILL: Project name] — [FILL: 1-sentence description]. [FILL: Tech stack, e.g. "TypeScript, React, Node.js"].' \
  "${PROJECT_NAME} — ${DESCRIPTION}. ${TECH_STACK}."

replace_literal "$F" \
  '[FILL: Constraint 1 — e.g. "No runtime dependencies — only stdlib"]' \
  "${CONSTRAINT_1}"

if [[ -n "${CONSTRAINT_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Constraint 2 — e.g. "All API calls must go through the gateway module"]' \
    "${CONSTRAINT_2}"
fi

replace_literal "$F" \
  '[FILL: Prohibition 1 — e.g. "Use localStorage or sessionStorage"]' \
  "${PROHIBITION_1}"

if [[ -n "${PROHIBITION_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Prohibition 2 — e.g. "Commit directly to main without a PR"]' \
    "${PROHIBITION_2}"
fi

replace_literal "$F" \
  '[FILL: List your key build/test/lint commands here, e.g.:

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

]' \
  "${SCRIPTS_BLOCK}"

replace_literal "$F" \
  '[FILL: test command, e.g. npm test]' \
  "${TEST_CMD}"

ok "$F"

# ─── AGENTS.md ───────────────────────────────────────────────────────────────
F="AGENTS.md"

replace_literal "$F" \
  '**[FILL: Project Name]** — [FILL: 1-2 sentence project description. What does it do? Who uses it?]' \
  "**${PROJECT_NAME}** — ${DESCRIPTION}"

replace_literal "$F" \
  '- **[FILL: Key architectural constraint 1]** — e.g. "No runtime frameworks, vanilla JS only"' \
  "- **${CONSTRAINT_1}**"

if [[ -n "${CONSTRAINT_2:-}" ]]; then
  replace_literal "$F" \
    '- **[FILL: Key architectural constraint 2]** — e.g. "Config-driven: all data in config/ files, never hardcode in templates"' \
    "- **${CONSTRAINT_2}**"
fi

replace_literal "$F" \
  '1. **[FILL: Rule 1]** — e.g. "No runtime frameworks"' \
  "1. **${CONSTRAINT_1}**"

if [[ -n "${CONSTRAINT_2:-}" ]]; then
  replace_literal "$F" \
    '2. **[FILL: Rule 2]** — e.g. "Config as Single Source of Truth"' \
    "2. **${CONSTRAINT_2}**"
fi

replace_literal "$F" \
  '[FILL: your test command, e.g. npm test]' \
  "${TEST_CMD}"

ok "$F"

# ─── .github/copilot-instructions.md ────────────────────────────────────────
F=".github/copilot-instructions.md"

replace_literal "$F" \
  '**[FILL: Project Name]** — [FILL: 1-sentence description. Tech stack. Target environment.]' \
  "**${PROJECT_NAME}** — ${DESCRIPTION}. ${TECH_STACK}."

replace_literal "$F" \
  '[FILL: Rule 1 — e.g. "Use vanilla JS — no frameworks, no runtime npm dependencies"]' \
  "${CONSTRAINT_1}"

if [[ -n "${CONSTRAINT_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Rule 2 — e.g. "Keep all data in config/*.js files"]' \
    "${CONSTRAINT_2}"
fi

replace_literal "$F" \
  '[FILL: Prohibition 1 — e.g. "Introduce frameworks, bundlers, or package managers"]' \
  "${PROHIBITION_1}"

if [[ -n "${PROHIBITION_2:-}" ]]; then
  replace_literal "$F" \
    '[FILL: Prohibition 2 — e.g. "Use localStorage, sessionStorage, cookies, or postMessage"]' \
    "${PROHIBITION_2}"
fi

ok "$F"

# ─── Remaining [FILL:] report ────────────────────────────────────────────────
echo ""
hr
echo -e "${BOLD}  Remaining [FILL:] markers (manual steps):${RESET}"
echo ""

FILES_TO_CHECK=(
  "CLAUDE.md"
  "AGENTS.md"
  "GEMINI.md"
  ".github/copilot-instructions.md"
  ".claude/agents/qa-reviewer.md"
  ".github/pull_request_template.md"
)

remaining=0
for f in "${FILES_TO_CHECK[@]}"; do
  count=$(count_fill "$f")
  if [[ "$count" -gt 0 ]]; then
    echo -e "  ${YELLOW}${f}${RESET}  (${count} remaining)"
    remaining=$((remaining + count))
  fi
done

if [[ $remaining -eq 0 ]]; then
  echo -e "  ${GREEN}None — all markers in key files are filled.${RESET}"
else
  echo ""
  echo -e "  ${YELLOW}To find all remaining markers:${RESET}"
  echo -e "    grep -rn '\\[FILL:' . --include='*.md'"
fi

# ─── Git hooks ───────────────────────────────────────────────────────────────
echo ""
hr
echo -e "${BOLD}  Git hooks${RESET}"
echo ""

if git -C "$REPO_ROOT" config core.hooksPath 2>/dev/null | grep -q '\.githooks'; then
  ok "Git hooks already active (.githooks)"
else
  read -rp "  Activate git hooks? (git config core.hooksPath .githooks) [y/N] " activate_hooks
  if [[ "$activate_hooks" =~ ^[Yy]$ ]]; then
    git -C "$REPO_ROOT" config core.hooksPath .githooks
    chmod +x "${REPO_ROOT}/.githooks/pre-commit" \
             "${REPO_ROOT}/.githooks/commit-msg" 2>/dev/null || true
    ok "Git hooks activated"
  else
    skip "Skipped. Run manually: git config core.hooksPath .githooks"
  fi
fi

# ─── Done ────────────────────────────────────────────────────────────────────
echo ""
hr
echo -e "${BOLD}  Setup complete.${RESET}"
echo ""
echo "  Next steps:"
echo "  1. Fill remaining markers listed above"
echo "     — AGENTS.md: file structure block, immutable contract, extra doc links"
echo "     — copilot-instructions.md: key files table, prohibition 3, context line"
echo "     — qa-reviewer.md: project-specific review rules"
echo "  2. Remove template sections that don't apply to your project"
echo "  3. Start your first AI agent session"
echo ""
hr
