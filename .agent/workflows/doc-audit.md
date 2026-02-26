---
description: Comprehensive documentation audit — ensures zero drift across ALL docs, agent instructions, and config files in the repo
---

# Documentation Audit Workflow

> Run this workflow after any non-trivial code change — or periodically — to guarantee zero documentation drift.
> Covers **all** documentation files, agent instructions, and root-level files.
>
> **Principle:** Use existing scripts instead of ad-hoc grep commands. Never create temporary audit scripts — use the repo's purpose-built tooling first.

<!-- SETUP: Fill in all [FILL: ...] placeholders to match your project's doc structure. -->

---

## Complete Documentation Inventory

<!-- SETUP: Replace the layer tables below with your project's actual doc structure. -->

### Layer 1: Primary Docs

| File | Content | Drift-sensitive fields |
| --- | --- | --- |
| `docs/README.md` | Project overview, quickstart, file tree | File tree, asset paths, tech stack |
| `docs/ARCHITECTURE.md` | Architecture, file layout, rendering pipeline | File paths, component structure |
| `docs/CHANGELOG.md` | Change log per version | Missing entries for recent changes |
| [FILL: Add further docs] | [FILL: Content description] | [FILL: Drift-sensitive fields] |

### Layer 2: Agent Instructions (AI coding rules)

| File | Content | Drift-sensitive fields |
| --- | --- | --- |
| `AGENTS.md` | Copilot/Codex rules | File structure (paths), coding rules |
| `CLAUDE.md` | Claude Code rules | File map (paths), key patterns |
| `.github/copilot-instructions.md` | Copilot persistent instructions | Key files table (paths), always/never rules |
| `.agent/rules/coding-standards.md` | Always-on coding rules | Rules, path conventions |

---

## Audit Procedure

### Phase 0: File Tree Completeness (Structural Drift)

Compare the **actual** file tree against **every file-map section** in agent instruction files and docs:

```bash
# List current files
ls src/
ls config/
ls docs/
```

Cross-check against file maps in `AGENTS.md`, `CLAUDE.md`, and `docs/ARCHITECTURE.md`.

**Common miss:** New scripts or docs directories added but not reflected in agent file maps.

### Phase 1: Identify What Changed

```bash
git diff --stat                          # What files changed?
git diff --name-only                     # Quick file list
git log --oneline -10                    # Recent commits
```

Classify the change type and identify which doc layers are affected.

### Phase 2: Run Automated Drift Checks

> Do not use ad-hoc grep commands for checks that existing scripts already cover.

```bash
# Run all automated tests and checks
npm test

# [FILL: Add any project-specific drift/stats scripts]
```

### Phase 3: Verify Path Conventions

Check that no doc still references old/phantom paths:

```bash
# Find references to potentially stale paths
grep -rn "[FILL: old-path-prefix]" docs/ .agent/ .claude/ .github/ AGENTS.md CLAUDE.md --include="*.md"
```

### Phase 4: Cross-Check Agent Instruction Files

All agent instruction files must agree on **facts** and **structural completeness**.

Key facts to verify consistency across AGENTS.md, CLAUDE.md, copilot-instructions.md, and coding-standards.md:

| Fact | Sources to cross-check |
| --- | --- |
| Coding rules | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| [FILL: Project-specific fact] | [FILL: Which files must agree] |

### Phase 5: Update CHANGELOG

If any doc fixes were made:

```markdown
### Fixed
- Documentation drift: updated [specific counts/paths/conventions] across [N] files
```

---

## Quick-Reference: Change → Doc Impact Matrix

<!-- SETUP: Fill in the impact matrix for your project. -->

| If you changed… | Update these docs |
| --- | --- |
| **File added/removed/renamed** | AGENTS.md (file structure), CLAUDE.md, docs/ARCHITECTURE.md |
| **Architecture decision** | `docs/decisions/` (add new ADR file) |
| **New feature / bug fix** | `docs/CHANGELOG.md` |
| **Coding rule changed** | AGENTS.md, CLAUDE.md, copilot-instructions.md, coding-standards.md |
| [FILL: Project-specific change] | [FILL: Affected docs] |

---

## Drift Severity Levels

| Level | Description | Action |
| --- | --- | --- |
| 🔴 **Critical** | Wrong paths, wrong schema, contradictory policy rules — agent will produce broken code | Fix immediately |
| 🟠 **High** | Missing files in agent file maps, outdated examples, stale conventions — agent may follow wrong patterns | Fix before next AI-assisted change |
| 🟡 **Medium** | Missing changelog entry, outdated roadmap — no code impact | Fix in next doc pass |
| 🟢 **Low** | Stylistic inconsistency, minor wording — cosmetic | Fix when convenient |
