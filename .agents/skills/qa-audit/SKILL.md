---
name: qa-audit
description: "Use when performing a quality audit, security review, or robustness check of [FILL: main-source-file]. Covers XSS/innerHTML scanning, rule compliance verification, race condition analysis, config schema validation, and documentation drift detection. Produces a severity-classified report (Critical/High/Medium/Low)."
---

# QA-Audit

> Systematic full-scope quality audit for `[FILL: main-source-file]` and its config ecosystem.

## Overview

This skill performs a comprehensive code quality audit covering security, robustness, rule compliance, and documentation drift. It produces a structured report with findings classified by severity.

The audit was designed based on real findings from production audits — it catches XSS vectors, race conditions, missing error guards, SVG injection points, and documentation drift that automated tools miss.

## When to Use

- **Periodic audits** — after major features or before releases
- **Security review** — when checking for XSS, injection, or unsafe data flows
- **Post-refactor verification** — when code changed significantly
- **Rule compliance check** — when verifying code follows all project conventions
- **Documentation drift detection** — when code values may have changed without updating docs
- **Pre-release quality gate** — as part of the release-readiness workflow

## The 9-Phase Process

| Phase | Focus | Output |
| --- | --- | --- |
| 0 | **Baseline** — Run `npm test`, `config-stats`, avatar verification | Green baseline confirmed |
| 1 | **Template Full Read** — Every line of HTML, CSS, JS | Zone-by-zone understanding |
| 2 | **Rule Compliance** — Compare code against ALL 8+ rule files | Rule violation findings |
| 3 | **Config Verification** — Schema conformity, cross-references | Schema/data integrity findings |
| 4 | **Security Scan** — innerHTML/XSS, SVG injection, forbidden APIs | Security findings |
| 5 | **Edge-Case & Robustness** — Race conditions, error propagation, guards | Robustness findings |
| 6 | **Documentation Drift** — Code IST vs. documented SOLL values | Drift findings |
| 7 | **Classification & Report** — Severity assignment, structured audit document | `QA-AUDIT-{date}.md` |
| 8 | **Fix Planning** — Risk per finding, fix order, verification plan | Fix roadmap |

## Scope Options

| Scope | Coverage |
| --- | --- |
| **Template-only** | `[FILL: main-source-file]` (HTML + CSS + JS) |
| **Config-included** | Template + all `config/*.js` files |
| **Full Scope Paranoid** | Template + Config + Agent Rules + Docs (recommended) |

## Severity Definitions

| Severity | Criteria | Examples |
| --- | --- | --- |
| **CRITICAL** | Security vulnerability or data loss risk | XSS via innerHTML, credential exposure |
| **HIGH** | Functional bug affecting users | UI freeze, broken navigation, lost state |
| **MEDIUM** | Rule violation, robustness gap, doku drift | Missing guard, wrong value in docs |
| **LOW** | Code hygiene, dead code, inconsistency | Unused variable, redundant style |

## Key Checks (Quick Reference)

### Security

- All `innerHTML` with config-/runtime-derived text uses `your-escape-fn()`
- `buildFallbackDataUri()` sanitizes colors via `sanitizeColor()`
- No `eval()`, `Function()`, `document.write()`, `postMessage`, `localStorage`

### Rule Compliance

- `touch-action: manipulation` on every interactive element
- `:hover` only inside `@media (hover: hover) and (pointer: fine)`
- `-webkit-tap-highlight-color: transparent` on all tappable elements
- All brand avatars via `your-asset-helper()` — no manual `<img>`
- All config uses IIFE + `Object.freeze`
- Relative paths only — no leading `/` or `./`

### Robustness

- Navigation has transition lock (prevents rapid double-tap)
- Confirm-item removal has isRemoving guard
- `handleSubscribe()` has try-catch around Supabase block
- Compatibility guard covers all required APIs

### Documentation Drift

- `.app-container` padding value matches ALL rule files
- `--app-chrome-height` value matches ALL rule files
- Footer padding-bottom formula is consistent
- Binding variant IDs are unchanged

## Rule Files to Check (ALL of these)

| File | Key sections |
| --- | --- |
| `AGENTS.md` | CSS Rules, JS Rules, SVG/Avatar Rules, Layout Constraints |
| `CLAUDE.md` | Critical Constraints, Do NOT |
| `.github/copilot-instructions.md` | Always Do, Never Do |
| `.claude/rules/css-touch.md` | Touch and hover rules |
| `.claude/rules/template-rendering.md` | Padding, footer, avatar rendering |
| `.claude/rules/config-patterns.md` | IIFE, Object.freeze, SSOT |
| `.agent/rules/coding-standards.md` | CSS/JS rules |
| `.agent/rules/-template.md` | File responsibilities, config schema |

## Report Output

Save to: `docs/docs--recommendation-template/QA-AUDIT-{YYYY-MM-DD}.md`

Update `QA-CHECKLIST.md` if new check categories are discovered.

## Full Procedure

→ See `.agent/workflows/qa-audit.md` for the complete step-by-step guide including Phase details, checklists, report template, and fix planning methodology.

→ For Claude Code users: use the `/qa-audit` slash command.
