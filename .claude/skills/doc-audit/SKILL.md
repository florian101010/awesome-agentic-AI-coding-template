---
name: doc-audit
description: 8-phase documentation drift audit across all docs, agent instructions, and config files. Use when checking for documentation drift, stale paths/counts, or inconsistencies between code and docs.
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
| [FILL: Additional agent instruction files] | [FILL: Drift-sensitive fields] |

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

