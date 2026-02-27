---
name: setup-repo
description: "Analyze this repository and auto-generate filled versions of all agent instruction files (CLAUDE.md, AGENTS.md, GEMINI.md, copilot-instructions.md, coding-standards.md, qa-reviewer.md). Replaces every [FILL:] marker with content derived from the actual codebase. Run this immediately after cloning the template into a new project."
---

# Setup Repo

## Overview

This skill reads the codebase, infers project-specific values from code, config files, and structure, then generates complete filled-in versions of every `[FILL:]` instruction file. It replaces the need to fill markers manually or run `setup.sh` alone.

**Announce at start:** "I'm using the setup-repo skill to generate your agent instruction files."

## When to Use

- Immediately after cloning this template into a new project
- When `setup.sh` has been run but deeper fills remain (file structure, coding standards, qa-reviewer checklist)
- When onboarding an existing codebase onto this template

## When NOT to Use

- On a repo that has no `[FILL:]` markers remaining (already fully set up)
- When you only need to update one specific file — edit it directly instead

## Prerequisites

**For Claude Code** — no setup needed; the skill reads files directly.

**For all other agents** — generate a repo bundle first, then paste it into the chat alongside this skill invocation:

```bash
npx repomix   # produces repomix-output.xml (already configured in this repo)
```

Attach or paste `repomix-output.xml` so the agent has full codebase context.

---

## Procedure

### Step 1 — Discover project facts

Read the codebase to establish these values before writing anything:

| Fact | Where to look |
| --- | --- |
| Project name | `package.json` `name`, directory name, existing `README.md` H1 |
| Description | `package.json` `description`, `README.md` intro paragraph |
| Tech stack | `package.json` `dependencies`/`devDependencies`, file extensions, import statements |
| Test command | `package.json` `scripts.test`, `Makefile`, `pyproject.toml`, `Cargo.toml` |
| Lint command | `package.json` `scripts.lint`, `.eslintrc*`, `.pre-commit-config.yaml` |
| Build command | `package.json` `scripts.build`, `Makefile`, `Dockerfile` |
| Constraints | `.githooks/`, CI config, architectural patterns repeated across the codebase |
| Prohibitions | ESLint/linter rules, existing code comments, patterns the codebase actively avoids |
| File structure | Top-level directories, entry points, key config files agents need to navigate |
| Immutable IDs | Values referenced in multiple places, stored data schemas, external API versions |

### Step 2 — Generate each file

Output complete filled content for every file listed below. For each:

- Replace **every** `[FILL:]` marker with a specific, accurate value
- Delete template sections that do not apply (e.g. remove `## Immutable Contract` if nothing is externally bound, remove `## Layout Constraints` if not a UI project)
- Keep all universal rules and non-placeholder content unchanged

**Files to generate (in order):**

1. `CLAUDE.md`
2. `AGENTS.md`
3. `GEMINI.md`
4. `.github/copilot-instructions.md`
5. `.claude/rules/coding-standards.md`
6. `.agent/rules/coding-standards.md`
7. `.kilocode/rules/coding-standards.md`
8. `.claude/agents/qa-reviewer.md`

### Step 3 — Quality-check every fill

Before outputting, verify each constraint and prohibition you write passes these tests:

| Test | Pass condition |
| --- | --- |
| **Specific** | Includes file paths, function names, or exact patterns — not vague intent |
| **Not code-inferable** | The agent cannot figure this out just by reading the source |
| **Actionable** | An agent can follow this rule without further clarification |
| **True** | You found evidence of this in the repo — not a guess |

**Good example:** `"No ORM — all DB queries in src/db/query.ts via raw SQL"`
**Bad example:** `"Use the database correctly"`

### Step 4 — Output format

Output each file with its path as a level-2 heading, followed by the complete file content in a fenced code block:

````markdown
## FILE: CLAUDE.md

```markdown
<complete file content here>
```

## FILE: AGENTS.md

```markdown
<complete file content here>
```
````

After all files, output a summary section:

```markdown
## Setup Summary

- **Files generated:** 8
- **[FILL:] markers resolved:** <count>
- **Sections removed (not applicable):** <list or "none">
- **Markers that needed a default (couldn't determine from code):** <list any with the defaults used>
```

---

## After Generating

Paste each file's content into the corresponding file, then verify:

```bash
# No unfilled markers should remain in key files
grep -rn "\[FILL:" CLAUDE.md AGENTS.md GEMINI.md .github/copilot-instructions.md

# Activate git hooks if not already active
git config core.hooksPath .githooks
```

Run your test command once to confirm the project baseline is healthy.
