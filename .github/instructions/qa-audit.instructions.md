---
name: 'QA Audit Process'
description: '9-phase security and robustness audit: XSS scan, rule compliance, config verification, and severity-classified report'
applyTo: "docs/QA-AUDIT-*.md,docs/QA-CHECKLIST.md,[FILL: main-source-file.html]"
---

# QA-Audit Instructions

<!-- SETUP: Replace [FILL: main-source-file] with your primary template/source file. -->

## When to Use

Apply this when performing a quality audit, security review, or robustness check of `[FILL: main-source-file]`.

## Audit Scope Options

- **Source-only** — Main source file (HTML + CSS + JS, or equivalent)
- **Config-included** — Source + all config files
- **Full Scope Paranoid** — Source + Config + Agent Rules + Docs (recommended)

## 9-Phase Process

1. **Baseline** — Run `npm test` and any config/asset verification scripts
2. **Source Full Read** — Read every section of the main source file
3. **Rule Compliance** — Verify code against ALL rule files (AGENTS.md, CLAUDE.md, copilot-instructions.md, `.claude/rules/`, `.agent/rules/`)
4. **Config Verification** — Schema conformity and cross-references between configs
5. **Security Scan** — All innerHTML + escaping, forbidden APIs, injection risks
6. **Edge-Case & Robustness** — Race conditions, error propagation, compatibility guards
7. **Documentation Drift** — Code IST vs. documented SOLL values across all rule files
8. **Classification & Report** — Severity: CRITICAL (security), HIGH (functional), MEDIUM (rules/robustness), LOW (hygiene)
9. **Fix Planning** — Risk per finding, fix order, verification method

## Key Security Checks

- Every `innerHTML` with config-/runtime-derived text MUST use a safe escaping function
- No `eval()`, `Function()`, `document.write()`, `postMessage`, `localStorage`
- [FILL: Project-specific security check 1]

## Key Rule Compliance Checks

- [FILL: Project-specific rule 1] — e.g. "touch-action: manipulation on every interactive element"
- [FILL: Project-specific rule 2] — e.g. "All assets rendered via a safe helper function with fallback"
- Relative paths only — no leading `/` or `./` (if applicable)

## Report Format

Save to `docs/QA-AUDIT-{YYYY-MM-DD}.md` with severity-classified findings including exact file/line references, violated rule, code snippet, impact, and fix suggestion.

## Full Procedure

See `.agent/workflows/qa-audit.md` for the complete step-by-step workflow.

