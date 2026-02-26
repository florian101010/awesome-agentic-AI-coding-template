---
name: doc-audit
description: 8-phase documentation drift audit across all docs, agent instructions, and config files. Use when checking for documentation drift, stale paths/counts, or inconsistencies between code and docs.
allowed-tools: Read, Grep, Glob, Bash
disable-model-invocation: true
---

# Documentation Audit

Comprehensive audit to ensure zero documentation drift across ALL docs, agent instructions, and config files.

**Principle:** Use existing scripts instead of ad-hoc grep commands. Never create temporary audit scripts — all checks are covered by the repo's tooling and test suite.

---

## Complete Documentation Inventory

### Layer 1: Primary Docs

<!-- SETUP: Replace with your project's actual doc structure. -->

| File | Drift-sensitive fields |
| --- | --- |
| `docs/README.md` | File tree, asset paths, tech stack |
| `docs/ARCHITECTURE.md` | File paths, component structure |
| `docs/CHANGELOG.md` | Missing entries for recent changes |
| [FILL: `docs/CONFIG-REFERENCE.md`] | [FILL: Schema tables, field descriptions] |
| `docs/decisions/` | ADR accuracy vs. current implementation |

### Layer 2: Agent Instructions

| File | Drift-sensitive fields |
| --- | --- |
| `AGENTS.md` | **File structure** (paths), coding rules |
| `CLAUDE.md` | **File map** (paths), key patterns |
| `.github/copilot-instructions.md` | Key files table (paths), always/never rules |
| `.agent/rules/coding-standards.md` | Rules, path conventions |
| `.claude/skills/add-brand/SKILL.md` | Same as above |

### Layer 3: Root-Level Files

| File | Drift-sensitive fields |
| --- | --- |
| `README.md` | File paths, quickstart instructions |
| [FILL: Add project-specific root-level files] | [FILL: Drift-sensitive fields] |

---

## Phase 0 — File Tree Completeness (Structural Drift)

> **Why this is Phase 0:** Missing files in file maps is the #1 drift source. Check this first.

Compare the **actual** file tree against **every file-map section** in agent instruction files and docs:

1. List actual files: `ls src/`, `ls config/`, `ls docs/`
2. Cross-check against file maps in:

| File | Section name |
| --- | --- |
| `AGENTS.md` | `## File Structure` |
| `CLAUDE.md` | `## File Map` |
| [FILL: `docs/README.md`] | [FILL: Section name for file tree] |

3. Every real file/directory must appear in all file maps. Flag any missing entries.

---

## Phase 1 — Identify What Changed

```bash
git diff --stat
git log --oneline -10
```

Classify the change type:
- **Config change** → schema, examples, stats references may be stale
- **UI/layout change** → styling guide, layout constraints may be stale
- **New feature** → user flow, architecture, changelog, roadmap may be stale
- **File added/removed/renamed** → file trees, path references may be stale
- **Agent rule change** → must propagate to ALL agent instruction files

---

## Phase 2 — Run Automated Drift Checks

> **Do not use ad-hoc grep commands or create temporary scripts for checks that existing tooling already covers.**

```bash
# Run all automated tests
npm test

# [FILL: Add any project-specific drift/stats scripts here]
```

Verify policy alignment:
- [ ] Agent docs do not hardcode mutable totals as static source-of-truth values
- [ ] If a snapshot number is documented, it is clearly labeled with snapshot context/date

---

## Phase 3 — Verify Path Conventions

```bash
# Find references to potentially stale paths
grep -rn "[FILL: old-path-prefix]" docs/ .agent/ .claude/ .github/ AGENTS.md CLAUDE.md --include="*.md"
```

**Current correct conventions:**
- [FILL: Path convention 1 — e.g. "No leading `/` or `./` in asset paths"]
- [FILL: Path convention 2 — e.g. "Assets at `assets/{name}.ext`"]

---

## Phase 4 — Verify Config ↔ Code Consistency

> **Use existing tooling** — do not write ad-hoc scripts for these checks.

All automated checks from Phase 2 cover config consistency. If they all pass, this phase is done.

---

## Phase 5 — Cross-Check Agent Files

### 5a. File map sync (structural)

Verify all files/directories in the repo are listed in the agent file maps (see Phase 0).

### 5b. Fact consistency

All agent instruction files must agree on:

| Fact | Must match across |
| --- | --- |
| Coding rules | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| Security requirements | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| [FILL: Project-specific fact] | [FILL: Which files must agree] |

---

## Phase 6 — Workflow & Skill Consistency

- [ ] `.agent/workflows/doc-audit.md` — This workflow is itself still accurate? (meta-audit)
- [ ] `.claude/skills/doc-audit/SKILL.md` — Same as above?
- [ ] `.github/pull_request_template.md` — Contains explicit docs/ADR/policy alignment gates?
- [ ] [FILL: Any project-specific workflows to check]

---

## Phase 7 — Update CHANGELOG

If any doc fixes were made:

```markdown
### Fixed
- Documentation drift: updated [specific counts/paths/conventions] across [N] files
```

---

## Change → Doc Impact Matrix

<!-- SETUP: Fill in the impact matrix for your project. -->

| If you changed… | Update these docs |
| --- | --- |
| **File added/removed/renamed** | AGENTS.md (file structure), CLAUDE.md (file map), docs/ARCHITECTURE.md |
| **Architecture decision** | `docs/decisions/` (add new ADR file) |
| **New feature / bug fix** | `docs/CHANGELOG.md` |
| **Coding rule changed** | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| [FILL: Project-specific change] | [FILL: Affected docs] |

---

## Drift Severity

| Level | Description | Action |
| --- | --- | --- |
| 🔴 Critical | Wrong paths, wrong schema, contradictory policy rules | Fix immediately |
| 🟠 High | Missing files in agent file maps, outdated conventions | Fix before next AI-assisted change |
| 🟡 Medium | Missing changelog entry, outdated roadmap | Fix in next doc pass |
| 🟢 Low | Stylistic inconsistency | Fix when convenient |


---

## Phase 1 — Identify What Changed

```bash
git diff --stat
git log --oneline -10
```

Classify the change type:
- **Config change** → schema, examples, derived stats references may be stale
- **UI/CSS change** → styling guide, layout constraints may be stale
- **New feature** → user flow, architecture, changelog, roadmap may be stale
- **File added/removed/renamed** → file trees, path references may be stale
- **Agent rule change** → must propagate to ALL agent instruction files

---

## Phase 2 — Run Automated Drift Checks

> **Do not use ad-hoc grep commands or create temporary scripts for checks that existing tooling already covers.**

Run all automated checks:

```bash
# 1. Derived stats — current source-of-truth counts
node scripts/config-stats.js --json

# 2. Count drift scanner — stale brand/category counts in docs
node scripts/config-drift-check.js

# 3. Avatar integrity — orphan files, missing refs, color validation
node scripts/verify-avatar-files.js

# 4. Unit tests — includes Data Integrity Audit (categoryIds consistency)
npm run test
```

**Script coverage:**

| Check | Script | What it catches |
| --- | --- | --- |
| Brand/category count drift | `scripts/config-drift-check.js` | Stale numbers in docs |
| Avatar file integrity | `scripts/verify-avatar-files.js` | Missing files, orphans, zero-byte, invalid colors |
| CategoryId consistency | `npm run test` (Data Integrity Audit) | Brand references non-existent category |
| Config stats snapshot | `scripts/config-stats.js --json` | Current counts for manual cross-check |

Verify policy alignment:
- [ ] Agent docs do not hardcode mutable totals as static source-of-truth values
- [ ] If a snapshot number is documented, it is clearly labeled with snapshot context/date
- [ ] Add-brand workflows/skills do not require manual count-sync steps

---

## Phase 3 — Verify Path Conventions

```bash
# Old flat avatar paths (should NOT appear except in changelogs)
grep -rn "template-assets/[a-z-]*\.svg" docs/ .agent/ .claude/ .github/ AGENTS.md CLAUDE.md --include="*.md" | grep -v CHANGELOG | grep -v DECISIONS | grep -v brand_avatars

# Old project name reference
grep -rn "design-tool-export/" docs/ .agent/ .claude/ .github/ AGENTS.md CLAUDE.md --include="*.md"

# Phantom file references (files mentioned but don't exist on disk)
grep -rn "default-brand\.svg\|discover-signup-urls" AGENTS.md CLAUDE.md .github/copilot-instructions.md --include="*.md"
```

**Current correct conventions:**
- Avatar SVGs: `template-assets/brand_avatars/{name}_avatar.svg`
- Empty src for fallback: `src: ''`
- No leading `/` or `./` in paths
- No `default-brand.svg` references (inline data URI fallback is used instead)

---

## Phase 4 — Verify Config ↔ Code Consistency

> **Use existing tooling** — do not write ad-hoc scripts for these checks.

All automated checks from Phase 2 cover config consistency. If they all pass, this phase is done.

- CategoryId validation → covered by `npm run test` (Data Integrity Audit)
- Avatar file existence → covered by `node scripts/verify-avatar-files.js`
- Count drift → covered by `node scripts/config-drift-check.js`

---

## Phase 5 — Cross-Check Agent Files

### 5a. File map sync (structural)

Verify all files/directories in the repo are listed in the agent file maps (see Phase 0).

### 5b. Fact consistency

All agent instruction files must agree on:

| Fact | Must match across |
| --- | --- |
| Avatar path convention | All agent files + CONFIG-REFERENCE.md |
| Fallback behavior | AGENTS.md, CLAUDE.md, coding-standards.md, ARCHITECTURE.md |
| Coding rules (CSS, JS) | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| `your-escape-fn()` requirement | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| Policy alignment (baseline + compatibility guard) | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md, project-template.md, pull_request_template.md |
| Language policy (if applicable) | All agent files, coding-standards.md |
| Testing checklist | AGENTS.md, CLAUDE.md |

---

## Phase 6 — Legacy Docs Accuracy

- [ ] `docs/ARCHITECTURE.md` — Old `design-tool-export/` paths? Update if so.
- [ ] `docs/CONFIG_REFERENCE.md` — project brands API section matches reality?
- [ ] `docs/FILE_REFERENCE.md` — All referenced files still present?
- [ ] `docs/STYLING_AND_LAYOUT.md` — Dimensions and CSS tokens match code?
- [ ] `docs/UX_AND_BEHAVIOR.md` — Query parameters and flows match code?

---

## Phase 7 — Workflow & Skill Consistency

- [ ] `.agent/workflows/add-brand.md` — Procedure matches current code patterns?
- [ ] `.claude/skills/add-brand/SKILL.md` — Same substance as above?
- [ ] `.agent/workflows/doc-audit.md` — This file itself still accurate? (meta-audit)
- [ ] `.claude/skills/doc-audit/SKILL.md` — Same as above?
- [ ] `.github/pull_request_template.md` — Contains explicit docs/ADR/policy alignment gates?

---

## Phase 8 — Update CHANGELOG

If any doc fixes were made:

```markdown
### Fixed
- Documentation drift: updated [specific counts/paths/conventions] across [N] files
```

---

## Change → Doc Impact Matrix

| If you changed… | Update these docs |
| --- | --- |
| **Brand added/removed** | `docs/CONFIG-REFERENCE.md`, add-brand skill |
| **Category added/removed** | `docs/CONFIG-REFERENCE.md` (category table), add-brand skill |
| **Step flow / navigation** | `docs/USER-FLOW.md`, `docs/ARCHITECTURE.md` |
| **CSS / layout** | `docs/STYLING-GUIDE.md` |
| **Config schema** | `docs/CONFIG-REFERENCE.md`, add-brand skill, `docs/ARCHITECTURE.md` |
| **File added / removed / renamed** | **AGENTS.md** (file structure), **CLAUDE.md** (file map), `docs/README.md` (file tree), `docs/ARCHITECTURE.md`, `docs/FILE_REFERENCE.md` |
| **Script added / removed** | **AGENTS.md** (file structure), **CLAUDE.md** (file map), `docs/README.md` (file tree) |
| **Avatar convention** | ALL agent files, `docs/CONFIG-REFERENCE.md`, `docs/decisions/`, add-brand skill |
| **Architecture decision** | `docs/decisions/` (add new ADR file, see `decisions/README.md` for template) |
| **New feature / bug fix** | `docs/CHANGELOG.md` |
| **Roadmap item completed** | `docs/ROADMAP.md` |
| **Coding rule changed** | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |

---

## Drift Severity

| Level | Description | Action |
| --- | --- | --- |
| 🔴 Critical | Wrong paths, wrong schema, contradictory policy rules | Fix immediately |
| 🟠 High | Missing files in agent file maps, outdated conventions | Fix before next AI-assisted change |
| 🟡 Medium | Missing changelog entry, outdated roadmap | Fix in next doc pass |
| 🟢 Low | Stylistic inconsistency | Fix when convenient |
