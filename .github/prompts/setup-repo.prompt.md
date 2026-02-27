---
name: 'setup-repo'
description: 'Fully configure this repo for a specific project — asks 3 questions, analyzes @workspace, then generates filled content for all 32 instruction files across all tiers'
agent: copilot
argument-hint: 'Optionally describe your project if context is not self-evident from the codebase'
---

You are configuring this AI coding template for a specific project. Your goal: zero `[FILL:]` markers remaining after this session.

## Step 0 — Ask the user 3 questions first

These answers cannot be inferred from code:

1. **Users & deployment:** "Who are the primary users and what is the deployment environment?"
2. **Immutable contract:** "Any externally-bound IDs, stored schemas, or API versions that must NEVER change? (answer 'none' to delete that section)"
3. **Extra prohibitions:** "Anything agents should never do that isn't obvious from reading the code?"

Wait for all three answers before analyzing anything.

## Step 1 — Gather project facts from @workspace

| Fact | Source |
| --- | --- |
| Project name & description | `package.json`, `README.md` H1 |
| Tech stack | `package.json` deps, file extensions |
| Test / lint / build commands | `package.json` scripts, `Makefile`, CI config |
| Architectural constraints | `.githooks/`, CI workflows, repeated code patterns |
| Prohibitions | Linter rules, code comments |
| File structure | Top-level dirs + entry points |
| Primary source file | Entry point (for audit skills) |

## Step 2 — Generate all files, tiered

### Tier 1 — Essential (output these first)

Generate complete filled content for:
- `CLAUDE.md`
- `AGENTS.md` (include a real file structure block from @workspace)
- `GEMINI.md`
- `.github/copilot-instructions.md`
- `.cursorrules`

### Tier 2 — Important (after user confirms Tier 1)

- `.claude/agents/qa-reviewer.md`
- `.claude/rules/coding-standards.md` (note: content mirrors to `.agent/rules/` and `.kilocode/rules/`)
- `.github/pull_request_template.md`
- `.github/prompts/new-feature.prompt.md`
- `.github/prompts/review-changes.prompt.md`
- `.github/instructions/docs.instructions.md`
- `.github/instructions/qa-audit.instructions.md`

### Tier 3 — Skill files (after user confirms Tier 2)

- `.claude/skills/qa-audit/SKILL.md` (note: mirrors to `.agents/skills/` and `.agent/skills/`)
- `.claude/skills/doc-audit/SKILL.md` (note: mirrors to `.agents/skills/` and `.agent/skills/`)

### Tier 4 — Workflows (complex — fill best-effort, flag unclear with `[REVIEW: reason]`)

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
- **Delete inapplicable sections:** `## Immutable Contract` if Q2 = "none"; layout/UI sections if not a UI project
- **Keep universal rules:** do not remove or alter non-placeholder content

## Output format

For each file output its path as a heading, then complete file content:

```
## FILE: CLAUDE.md
<complete content>

## FILE: AGENTS.md
<complete content>
```

After all tiers, output:

```
## Setup Summary
- Files generated: <count>
- [FILL:] markers resolved: <count>
- [REVIEW:] markers flagged: <list>
- Sections deleted: <list or "none">
```

## After the user applies each file

Remind them to:

```bash
# Activate git hooks
git config core.hooksPath .githooks

# Verify no markers remain
grep -rn "\[FILL:" . --include="*.md" | grep -v README | grep -v CHANGELOG | grep -v CUSTOMIZATION-GUIDE | grep -v SKILLS-CATALOG
```
