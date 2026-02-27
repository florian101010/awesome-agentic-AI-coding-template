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
| **Source-only** | `[FILL: main-source-file]` | Medium |
| **Config-included** | Source + all config files | Medium-Large |
| **Full Scope Paranoid** | Source + Config + Agent Rules + Docs (all layers) | Large |

Default: **Full Scope Paranoid** (recommended for periodic audits or after major changes).

---

## Phase 0 — Baseline & Preparation

> Establish a green baseline before the audit begins.

1. **Run tests** — `[FILL: test command, e.g. npm test]` must pass
2. **Run project-specific verification** — [FILL: e.g. "node scripts/config-stats.js --json" or remove if N/A]
3. **Note branch and commit** — Record current branch and HEAD commit for the audit report header
4. **Count source lines** — `wc -l [FILL: main-source-file]` to set scope expectation

If any check fails → fix first, then start the audit.

---

## Phase 1 — Source Full Read (Line-by-Line)

> Read the entire `[FILL: main-source-file]` — every line matters. Do NOT skip sections.

Divide the source into logical zones and read each completely:

<!-- SETUP: Replace zones with your project's actual structure -->

| Zone | Content | Focus |
| --- | --- | --- |
| [FILL: Zone 1] | [FILL: e.g. "Configuration, imports"] | [FILL: e.g. "Dependency correctness"] |
| [FILL: Zone 2] | [FILL: e.g. "Core logic"] | [FILL: e.g. "Error handling, edge cases"] |
| [FILL: Zone 3] | [FILL: e.g. "UI / rendering"] | [FILL: e.g. "XSS, accessibility"] |
| [FILL: Zone 4] | [FILL: e.g. "Event handlers"] | [FILL: e.g. "Race conditions, guards"] |

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
| `AGENTS.md` | Coding Rules, Immutable Contract |
| `.github/copilot-instructions.md` | Always Do / Never Do lists |
| `CLAUDE.md` | Critical Constraints, Do NOT section |
| `.agent/rules/coding-standards.md` | Rules, conventions |
| [FILL: additional rule files] | [FILL: key rules] |

### Checklist

<!-- SETUP: Replace with your project's actual rule checks -->

- [ ] [FILL: Rule check 1 — e.g. "Every interactive element has touch-action: manipulation"]
- [ ] [FILL: Rule check 2 — e.g. "All paths are relative — no leading / or ./"]
- [ ] [FILL: Rule check 3 — e.g. "All config exports use IIFE + Object.freeze"]
- [ ] [FILL: Rule check 4 — e.g. "All innerHTML with dynamic text uses safe escaping"]
- [ ] [FILL: Rule check 5 — additional project-specific checks]

---

## Phase 3 — Config Verification

> Verify config files for schema conformity and completeness.

### Files to check

<!-- SETUP: Replace with your project's actual config files -->

| Config file | Key checks |
| --- | --- |
| [FILL: `config/app-config.js`] | [FILL: Required fields, no duplicate IDs] |
| [FILL: `config/feature-flags.js`] | [FILL: All flags documented, no dead flags] |

### Cross-references

- [ ] [FILL: Cross-reference check 1 — e.g. "Every ID reference points to an existing entity"]
- [ ] [FILL: Cross-reference check 2 — e.g. "Config schema matches TypeScript interface"]

---

## Phase 4 — Security Scan

> Identify XSS vectors, injection points, and unsafe data flows.

### innerHTML / DOM injection audit

Search for ALL dynamic DOM insertions in the source. For each:

- [ ] Is the inserted content static? → Safe
- [ ] Is config-derived text inserted? → Must use a safe escaping function
- [ ] Is runtime/error text inserted? → Must use a safe escaping function
- [ ] Is user input inserted? → Must use a safe escaping function

### Forbidden APIs

- [ ] No `eval()`, `Function()`, or `document.write()` usage
- [ ] [FILL: Additional forbidden API checks — e.g. "No postMessage listeners", "No localStorage"]

### [FILL: Project-specific security checks]

- [ ] [FILL: e.g. "Color sanitization uses strict regex before SVG embedding"]
- [ ] [FILL: e.g. "No hardcoded credentials or API keys"]

---

## Phase 5 — Edge-Case & Robustness Analysis

> Identify race conditions, missing guards, and error propagation gaps.

### Race conditions

- [ ] [FILL: Race condition 1 — e.g. "Rapid navigation — is there a transition lock?"]
- [ ] [FILL: Race condition 2 — e.g. "Concurrent API calls — are they deduplicated?"]

### Error propagation

- [ ] [FILL: Error check 1 — e.g. "Main handler has try-catch around external calls"]
- [ ] [FILL: Error check 2 — e.g. "Init error handler covers all error types"]
- [ ] Network failures in `fetch()` calls — are they caught and logged?

### Compatibility

- [ ] [FILL: Compatibility check — e.g. "Feature detection guard covers all required APIs"]
- [ ] Failure mode shows a user-facing message (not a blank screen)
- [ ] Application degrades gracefully if optional features are unavailable

---

## Phase 6 — Documentation Drift (Full Scope only)

> Compare code IST-values against documented SOLL-values.

### Values to cross-check

<!-- SETUP: Replace with your project's actual drift-sensitive values -->

| Value | Code location | Documented in |
| --- | --- | --- |
| [FILL: Value 1] | [FILL: Code location] | [FILL: Which docs] |
| [FILL: Value 2] | [FILL: Code location] | [FILL: Which docs] |
| [FILL: Immutable IDs] | [FILL: Code location] | [FILL: AGENTS.md, CLAUDE.md] |

### Methodology

1. Extract the actual value from code
2. grep for the same value in ALL rule files
3. If any file has a different value → that's documentation drift → log as finding

---

## Phase 7 — Finding Classification & Report

> Classify every finding and produce a structured report.

### Severity Definitions

| Severity | Criteria | Examples |
| --- | --- | --- |
| **CRITICAL** | Security vulnerability or data loss risk | XSS via innerHTML, credential exposure |
| **HIGH** | Functional bug affecting users | UI freeze, broken navigation, lost state |
| **MEDIUM** | Rule violation, robustness gap, doc drift | Missing guard, inconsistent value in docs |
| **LOW** | Code hygiene, dead code, minor inconsistency | Unused variable, redundant style |

### Report Format

Create `docs/QA-AUDIT-{YYYY-MM-DD}.md` with:

```markdown
# QA-Audit: [FILL: main-source-file]

> **Date:** {ISO timestamp}
> **Branch:** {branch name}
> **Source:** {line count} lines
> **Tests:** {X}/{X} pass
> **Scope:** {scope}

---

## Severity Legend
(table)

## CRITICAL ({count})
### C1 — {title}
**File/Line — Rule — Code Snippet — Impact — Status**

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
3. **MEDIUM** — Discuss risk with user, some may need clarification (e.g., doc drift vs. code bug)
4. **LOW** — Optional, fix only if user requests

### Risk Assessment per Finding

For each finding, determine:

| Factor | Question |
| --- | --- |
| **Fix risk** | Can this fix break existing behavior? |
| **Scope** | How many files are touched? |
| **Dependency** | Does this fix depend on another fix? |
| **Verification** | How to verify the fix works? (tests, visual check, manual test) |

### After Fixes

1. Run `[FILL: test command]` — must still pass
2. [FILL: Additional post-fix verification steps]
3. Update the audit report — mark fixed findings with ✅ FIXED + timestamp
4. Update `QA-CHECKLIST.md` if new check categories were discovered
5. Run pre-commit checks before committing

---

## Post-Audit Checklist

- [ ] Audit report saved to `docs/QA-AUDIT-{date}.md`
- [ ] All C/H findings either fixed or explicitly deferred with justification
- [ ] Tests pass after all fixes
- [ ] Updated audit report with fix statuses
- [ ] `QA-CHECKLIST.md` updated if new check types were discovered
- [ ] Commit with format `audit(scope): QA-Audit {date} — {summary}`
