---
description: Full-scope QA audit of [FILL: main-source-file] — systematic code analysis including security, robustness, rule compliance, and documentation drift
---

# QA-Audit Workflow

> Run this workflow to perform a comprehensive quality audit of the project codebase.
> Produces a timestamped audit report with findings classified by severity (Critical / High / Medium / Low).
>
> **Principle:** Read-only analysis first — no changes until the user approves fixes. Use existing tests and scripts, never create temporary audit scripts.

---

## Scoping

Before starting, determine audit scope with the user:

| Scope | What is audited | Typical duration |
| --- | --- | --- |
| **Template-only** | `[FILL: main-source-file]` (HTML + CSS + JS) | Medium |
| **Config-included** | Template + all `config/*.js` files | Medium-Large |
| **Full Scope Paranoid** | Template + Config + Agent Rules + Docs (all layers) | Large |

Default: **Full Scope Paranoid** (recommended for periodic audits or after major changes).

---

## Phase 0 — Baseline & Preparation

> Establish a green baseline before the audit begins.

1. **Run unit tests** — `npm test` must pass (all tests green)
2. **Run config-stats** — `node scripts/config-stats.js --json` to capture current counts (brands, categories, avatars)
3. **Run avatar verification** — `node scripts/verify-avatar-files.js`
4. **Note branch and commit** — Record current branch and HEAD commit for the audit report header
5. **Count template lines** — `wc -l [FILL: main-source-file]` to set scope expectation

If any check fails → fix first, then start the audit.

---

## Phase 1 — Template Full Read (Line-by-Line)

> Read the entire `[FILL: main-source-file]` — every line matters. Do NOT skip sections.

Divide the template into logical zones and read each completely:

| Zone | Content | Focus |
| --- | --- | --- |
| **HTML `<head>`** | Meta tags, viewport, fonts | Viewport config, WebView compatibility |
| **CSS `<style>`** | Custom properties, component styles | Touch rules, hover guards, layout values |
| **HTML `<body>`** | Step containers, markup, structure | Semantic correctness, accessibility |
| **JS `<script>`** | IIFE, state management, rendering, navigation | Logic correctness, error handling, XSS |

For each zone, note:
- Anything that looks fragile or inconsistent
- Hardcoded values that should come from config
- Missing error handling or guard conditions

---

## Phase 2 — Rule Compliance Check

> Verify every code section against the project's documented rules.

### Rule Sources (check ALL of these)

| File | Key rules to verify |
| --- | --- |
| `AGENTS.md` | CSS Rules §1–7, JS Rules §1–8, SVG/Avatar Rules §1–5 |
| `.github/copilot-instructions.md` | Always Do / Never Do lists |
| `CLAUDE.md` | Critical Constraints, Do NOT section |
| `.claude/rules/css-touch.md` | Touch-action, hover guards, tap-highlight, overscroll |
| `.claude/rules/template-rendering.md` | Padding, footer, avatar rendering |
| `.claude/rules/config-patterns.md` | IIFE + Object.freeze, SSOT pattern |
| `.agent/rules/coding-standards.md` | CSS/JS rules, asset path conventions |
| `.agent/rules/-template.md` | File responsibilities, config schema, avatar system |

### Checklist

- [ ] Every interactive element has `touch-action: manipulation`
- [ ] Every interactive element has `-webkit-tap-highlight-color: transparent`
- [ ] Every `:hover` rule is inside `@media (hover: hover) and (pointer: fine)`
- [ ] `overscroll-behavior: none` on html/body
- [ ] `user-select: none` on chips and cards
- [ ] All paths are relative — no leading `/` or `./`
- [ ] All config exports use IIFE + `Object.freeze`
- [ ] All brand avatars rendered via `your-asset-helper()` — no manual `<img>` tags
- [ ] All `innerHTML` insertions of config-/runtime-derived text use `your-escape-fn()`
- [ ] Compatibility guard checks `Set`, `Map`, `find`, `includes`, `requestAnimationFrame`

---

## Phase 3 — Config Verification

> Verify config files for schema conformity and completeness.

### Files to check

| Config file | Key checks |
| --- | --- |
| `config/-brands-config.js` | Every brand has all required fields (`id`, `name`, `description`, `categoryIds`, `avatar`, `signupUrl`, `featured`, `sortOrder`); `DEFAULT_AVATAR` has all 4 fields (`src`, `initials`, `background`, `textColor`); no duplicate IDs |
| `config/-categories-config.js` | Every category has `id`, `label`, `color`; no duplicate IDs; IDs used in brands all exist |
| `config/-ui-config.js` | Provider address form matches (provider-A=informal, provider-B=formal); all text keys present |
| `config/escape-html.js` | `your-escape-fn()` handles all 5 HTML entities (`&`, `<`, `>`, `"`, `'`) |

### Cross-references

- [ ] Every `categoryIds` entry in brands references an existing category ID
- [ ] Every `avatar.src` that is non-empty points to an existing file in `template-assets/brand_avatars/`
- [ ] `DEFAULT_AVATAR` field set matches the avatar object schema used by brands

---

## Phase 4 — Security Scan

> Identify XSS vectors, injection points, and unsafe data flows.

### innerHTML audit

Search for ALL `innerHTML` usages in the template. For each:

- [ ] Is the inserted content static HTML? → Safe
- [ ] Is config-derived text inserted? → Must use `your-escape-fn()`
- [ ] Is runtime error text inserted? → Must use `your-escape-fn()`
- [ ] Is user input inserted? → Must use `your-escape-fn()` (should not exist in this template)

### SVG injection audit

- [ ] `buildFallbackDataUri()` sanitizes color values before embedding in SVG
- [ ] Color sanitization uses a strict regex (e.g., `/^#[0-9a-fA-F]{3,8}$/`)
- [ ] Invalid colors fall back to safe defaults

### API / External data

- [ ] No `eval()`, `Function()`, or `document.write()` usage
- [ ] No `postMessage` listeners (template must be self-contained)
- [ ] No `localStorage`, `sessionStorage`, or cookie access

---

## Phase 5 — Edge-Case & Robustness Analysis

> Identify race conditions, missing guards, and error propagation gaps.

### Race conditions

- [ ] Rapid navigation (double-tap on CTA buttons) — is there a transition lock?
- [ ] Rapid remove (swipe + X-button simultaneously on confirm items) — is there an isRemoving guard?
- [ ] Scroll momentum + button tap — can interaction fire during scroll?

### Error propagation

- [ ] `handleSubscribe()` — what happens if Supabase/crypto calls fail? Does the user still reach Success?
- [ ] `handleInitError()` — does it safely handle all error types (string, Error object, null)?
- [ ] Network failures in `fetch()` calls — are they caught and logged?

### Compatibility

- [ ] Compatibility guard covers all required APIs
- [ ] Guard failure shows a user-facing message (not a blank screen)
- [ ] Template degrades gracefully if optional features are unavailable

---

## Phase 6 — Documentation Drift (Full Scope only)

> Compare code IST-values against documented SOLL-values.

### Values to cross-check

| Value | Code location | Documented in |
| --- | --- | --- |
| `.app-container` padding | CSS in `[FILL: main-source-file]` | AGENTS.md, CLAUDE.md, STYLING-GUIDE.md, coding-standards.md, css-touch.md, template-rendering.md |
| `--app-chrome-height` | CSS custom property | Same files as above |
| Footer `padding-bottom` formula | CSS in template | AGENTS.md §CSS-7 |
| Brand avatar size (Step 2 / Step 3) | CSS in template | AGENTS.md §Layout Constraints |
| Font stack | CSS in template | AGENTS.md §Layout Constraints |
| Viewport meta | `<meta>` tag | AGENTS.md §Layout Constraints |
| Binding variant IDs | JS / deeplinks | AGENTS.md, CLAUDE.md (must never change) |

### Methodology

1. Extract the actual value from code
2. grep for the same value in ALL rule files (9+ files)
3. If any file has a different value → that's documentation drift → log as finding

---

## Phase 7 — Finding Classification & Report

> Classify every finding and produce a structured report.

### Severity Definitions

| Severity | Criteria | Examples |
| --- | --- | --- |
| **CRITICAL** | Security vulnerability or data loss risk | XSS via innerHTML, credential exposure |
| **HIGH** | Functional bug affecting users | UI freeze, broken navigation, lost state |
| **MEDIUM** | Rule violation, robustness gap, doku drift | Missing guard, inconsistent value in docs |
| **LOW** | Code hygiene, dead code, minor inconsistency | Unused variable, redundant style, cursor:pointer |

### Report Format

Create `docs/docs--recommendation-template/QA-AUDIT-{YYYY-MM-DD}.md` with:

```markdown
# QA-Audit: [FILL: main-source-file]

> **Datum:** {ISO timestamp}
> **Branch:** {branch name}
> **Template:** {line count} Zeilen
> **Unit Tests:** {X}/{X} pass
> **Modus:** {scope}

---

## Severity Legend
(table)

## CRITICAL ({count})
### C1 — {title}
**Datei/Zeile — Regel — Code-Snippet — Impact — Status**

## HIGH ({count})
...

## MEDIUM ({count})
...

## LOW ({count})
...
```

Each finding must include:
- **File and line reference** (exact, not approximate)
- **Which rule it violates** (file + section)
- **Code snippet** showing the problem
- **Impact description** (what can go wrong)
- **Fix suggestion** (concrete, not vague)

---

## Phase 8 — Fix Planning (Post-Report)

> After the report is reviewed, plan fixes by severity and risk.

### Fix Order

1. **CRITICAL** — Fix immediately, zero risk tolerance
2. **HIGH** — Fix next, explain risk before applying
3. **MEDIUM** — Discuss risk with user, some may need clarification (e.g., doku drift vs. code bug)
4. **LOW** — Optional, fix only if user requests

### Risk Assessment per Finding

For each finding, determine:

| Factor | Question |
| --- | --- |
| **Fix risk** | Can this fix break existing behavior? |
| **Scope** | How many files are touched? |
| **Dependency** | Does this fix depend on another fix? |
| **Verification** | How to verify the fix works? (`npm test`, visual check, manual test) |

### After Fixes

1. Run `npm test` — must still pass
2. After adding/removing brands: `npm run test:sync-baseline`
3. Update the audit report — mark fixed findings with ✅ FIXED + timestamp
4. Update `QA-CHECKLIST.md` if new check categories were discovered
5. Run `.githooks/pre-commit` before committing

---

## Post-Audit Checklist

- [ ] Audit report saved to `docs/docs--recommendation-template/QA-AUDIT-{date}.md`
- [ ] All C/H findings either fixed or explicitly deferred with justification
- [ ] `npm test` passes after all fixes
- [ ] Updated audit report with fix statuses
- [ ] `QA-CHECKLIST.md` updated if new check types were discovered
- [ ] Commit with format `audit(template): QA-Audit {date} — {summary}`
