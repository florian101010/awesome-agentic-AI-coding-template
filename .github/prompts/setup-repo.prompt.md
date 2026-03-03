---
name: 'setup-repo'
description: 'Fully configure this repo for a specific project — asks 4 questions (including which AI tools you use), auto-detects the tech stack, then generates filled content only for the active agent files'
agent: copilot
argument-hint: 'Optionally describe your project if context is not self-evident from the codebase'
---

You are configuring this AI coding template for a specific project. Your goal: zero `[FILL:]` markers remaining in files for the AI tools you actually use.

## Step 0 — Ask the user 4 questions first

These answers cannot be inferred from code:

1. **AI tools in use:** "Which AI coding tools will you use with this repo? (Select all that apply: Claude Code · GitHub Copilot · Cursor · Google Jules · Gemini / Antigravity · Kilo Code · All of the above)"
2. **Users & deployment:** "Who are the primary users and what is the deployment environment?"
3. **Immutable contract:** "Any externally-bound IDs, stored schemas, or API versions that must NEVER change? (answer 'none' to delete that section)"
4. **Extra prohibitions:** "Anything agents should never do that isn't obvious from reading the code?"

Wait for all four answers before analyzing anything. Store the answer to question 1 as the **active agent set**.

## Step 1 — Auto-detect project facts from @workspace

Use this detection table first — only ask the user if detection is ambiguous:

| Signal | Auto-detected value |
| --- | --- |
| `package.json` → `scripts.test` | test command (exact value) |
| `package.json` → `scripts.lint` | lint command (exact value) |
| `package.json` → `scripts.build` | build command (exact value) |
| `pyproject.toml` present, no `package.json` | test = `pytest`, stack = Python |
| `Cargo.toml` present | test = `cargo test`, stack = Rust |
| `go.mod` present | test = `go test ./...`, stack = Go |
| `Makefile` with `test:` target | test = `make test` (if no other signal) |
| `tsconfig.json` present | stack includes TypeScript |
| `.eslintrc*` or `eslint.config.*` present | lint tool = ESLint |

Also gather from @workspace:

| Fact | Source |
| --- | --- |
| Project name & description | `package.json`, `README.md` H1 |
| Tech stack | `package.json` deps, file extensions |
| Architectural constraints | `.githooks/`, CI workflows, repeated code patterns |
| Prohibitions | Linter rules, code comments |
| File structure | Top-level dirs + entry points |
| Primary source file | Entry point (for audit skills) |

## Step 1.5 — Output `project-context.json` first

Before any instruction file, output the contents of `project-context.json`:

```json
{
  "project_name": "<detected>",
  "description": "<detected>",
  "tech_stack": "<detected>",
  "agents": ["<keys from question 1, e.g. claude, copilot>"],
  "constraints": ["<constraint 1>", "<constraint 2>"],
  "prohibitions": ["<prohibition 1>", "<prohibition 2>"],
  "commands": {
    "test": "<detected or user-provided>",
    "lint": "<detected or user-provided>",
    "build": "<detected or user-provided>"
  }
}
```

Agent key mapping: Claude Code → `"claude"` · GitHub Copilot → `"copilot"` · Cursor → `"cursor"` · Jules → `"jules"` · Gemini → `"gemini"` · Kilo Code → `"kilocode"`

## Step 2 — Generate files, tiered, for active agents only

**Skip files for AI tools not in the active agent set.**

| Active agent | Files to generate |
| --- | --- |
| `[ALL]` | `CLAUDE.md`, `AGENTS.md` |
| `claude` | `.claude/` (all subdirs), `.cursorrules` |
| `copilot` | `.github/copilot-instructions.md`, `.github/prompts/`, `.github/instructions/`, `.github/pull_request_template.md` |
| `cursor` | `.cursorrules` |
| `jules` or `gemini` | `.agent/` (rules, workflows, skills), `GEMINI.md` |
| `kilocode` | `.kilocode/rules/` |

### Tier 1 — Essential (output these first)

Generate complete filled content for:
- `CLAUDE.md` `[ALL]`
- `AGENTS.md` `[ALL]` — include a real file structure block from @workspace
- `GEMINI.md` `[jules/gemini only]`
- `.github/copilot-instructions.md` `[copilot only]`
- `.cursorrules` `[claude/cursor only]`

### Tier 2 — Important (after user confirms Tier 1)

- `.claude/agents/qa-reviewer.md` `[claude only]`
- `.claude/rules/coding-standards.md` `[claude only]` (note: mirrors to `.agent/rules/` and `.kilocode/rules/` for active agents)
- `.github/pull_request_template.md` `[copilot only]`
- `.github/prompts/new-feature.prompt.md` `[copilot only]`
- `.github/prompts/review-changes.prompt.md` `[copilot only]`
- `.github/instructions/docs.instructions.md` `[copilot only]`
- `.github/instructions/qa-audit.instructions.md` `[copilot only]`

### Tier 3 — Skill files (after user confirms Tier 2)

- `.claude/skills/qa-audit/SKILL.md` `[claude only — source of truth]` (mirrors to `.agents/skills/` and `.agent/skills/` for active agents)
- `.claude/skills/doc-audit/SKILL.md` `[claude only — source of truth]` (mirrors to active agent directories)

### Tier 4 — Workflows `[jules/gemini only]`

- `.agent/workflows/qa-audit.md`
- `.agent/workflows/pr-analysis.md`
- `.agent/workflows/feature-delivery.md`
- `.agent/workflows/doc-audit.md`
- `.agent/workflows/architecture-change.md`
- `.agent/workflows/release-readiness.md`
- `.agent/workflows/post-merge-analysis.md`

## Fill quality rules

- **Specific:** include file paths, function names, exact patterns — never vague intent
- **Evidence-based:** only write what you found in @workspace or user answers
- **Delete inapplicable sections:** `## Immutable Contract` if Q3 = "none"; layout/UI sections if not a UI project
- **Keep universal rules:** do not remove or alter non-placeholder content

## Output format

For each file output its path as a heading, then complete file content:

```
## FILE: project-context.json
<complete content>

## FILE: CLAUDE.md
<complete content>

## FILE: AGENTS.md
<complete content>
```

After all tiers, output:

```
## Setup Summary
- Active agents: <list>
- Files generated: <count>
- Files skipped (inactive agents): <count>
- [FILL:] markers resolved: <count>
- [REVIEW:] markers flagged: <list>
- Auto-detected: test=<cmd>, lint=<cmd>, build=<cmd>
- Sections deleted: <list or "none">
```

## After the user applies each file

Remind them to:

```bash
# Activate git hooks
git config core.hooksPath .githooks

# Verify no markers remain in active files
grep -rn "\[FILL:" . --include="*.md" --include="*.yaml" --include="*.yml" --include="*.cursorrules" \
  | grep -v ".git/" \
  | grep -v "README.md" \
  | grep -v "CHANGELOG.md" \
  | grep -v "docs/CUSTOMIZATION-GUIDE.md" \
  | grep -v "docs/SKILLS-CATALOG.md"
```
