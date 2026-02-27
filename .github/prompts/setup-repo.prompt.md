---
name: 'setup-repo'
description: 'Analyze this repo and generate filled agent instruction files — replacing every [FILL:] marker with content derived from the actual codebase'
agent: copilot
argument-hint: 'Optionally describe your project if context is not self-evident'
---

You are configuring an AI coding template for a specific project. Analyze @workspace and generate complete, filled-in versions of every agent instruction file that still contains `[FILL:]` markers.

## What to analyze

Read the codebase to establish:

| Fact | Where to look |
| --- | --- |
| Project name & description | `package.json`, `README.md`, directory name |
| Tech stack | `package.json` dependencies, file extensions, import statements |
| Test / lint / build commands | `package.json` scripts, `Makefile`, `pyproject.toml`, CI config |
| Architectural constraints | `.githooks/`, CI workflows, patterns repeated across source files |
| Prohibitions | Linter rules, code comments, patterns the codebase actively avoids |
| File structure | Top-level dirs, entry points, key config files |
| Immutable IDs | Values referenced across multiple files, stored schemas, external API versions |

## Files to generate

Produce complete filled content for each of these (in order):

1. `CLAUDE.md`
2. `AGENTS.md`
3. `GEMINI.md`
4. `.github/copilot-instructions.md`
5. `.claude/rules/coding-standards.md`
6. `.agent/rules/coding-standards.md`
7. `.kilocode/rules/coding-standards.md`
8. `.claude/agents/qa-reviewer.md`

## Rules for every fill

- **Specific over vague** — `"No ORM — raw SQL only in src/db/"` beats `"use the database correctly"`
- **Evidence-based** — only write constraints you found evidence for in the repo
- **Delete inapplicable sections** — remove `## Immutable Contract` if nothing is externally bound; remove UI/layout sections if not a UI project
- **Keep universal content** — do not remove or alter rules that are not placeholders

## Output format

For each file output the path as a heading followed by the complete file content:

```
## FILE: CLAUDE.md
<complete content>

## FILE: AGENTS.md
<complete content>
```

End with a summary:

```
## Setup Summary
- Files generated: 8
- [FILL:] markers resolved: <count>
- Sections removed: <list or "none">
- Defaults used (couldn't determine from code): <list>
```

## After generating

The user should paste each file's content into the corresponding file, then run:

```bash
grep -rn "\[FILL:" CLAUDE.md AGENTS.md GEMINI.md .github/copilot-instructions.md
git config core.hooksPath .githooks
```
