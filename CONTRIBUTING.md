# Contributing to Awesome Agentic AI Coding Template

Thank you for your interest in contributing. This document explains how to get involved and what kinds of contributions are most valuable.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [What We're Looking For](#what-were-looking-for)
- [How to Contribute](#how-to-contribute)
- [Adding a New Skill](#adding-a-new-skill)
- [Improving an Existing Skill or Workflow](#improving-an-existing-skill-or-workflow)
- [Reporting Issues](#reporting-issues)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold it.

---

## What We're Looking For

The most valuable contributions to this template:

**New universal skills** — Skills that apply to any software project, not just a specific tech stack. Examples:
- Accessibility audit skill
- Performance profiling skill
- Dependency security review skill
- API contract validation skill

**New workflow procedures** — Structured multi-phase workflows for common engineering tasks not yet covered.

**Agent-specific improvements** — Better config patterns as new AI tools evolve and introduce new capabilities.

**Bug fixes and clarity improvements** — Corrections to existing skill definitions, workflow steps, or instruction files that are ambiguous, incorrect, or outdated.

**Documentation improvements** — Clearer setup guides, better examples, improved placeholder annotations.

What we are **not** looking for:

- Project-specific skills or workflows (e.g. skills for a specific framework or library — these belong in your own project's config, not this template)
- Runtime dependencies or build steps (this is a static file template)
- Framework-specific boilerplate

---

## How to Contribute

1. **Fork** the repository and create a branch from `main`:

   ```bash
   git checkout -b feat/my-new-skill
   ```

2. **Make your changes** — see the sections below for specific guidance.

3. **Test your changes** by using the template in an actual project.

4. **Commit** using [conventional commit format](https://www.conventionalcommits.org/):

   ```text
   feat(skills): add accessibility-audit skill
   fix(workflows): correct phase numbering in doc-audit
   docs(readme): improve quick start formatting
   ```

5. **Open a pull request** against `main`. Use the PR template — it will be shown automatically.

---

## Adding a New Skill

Skills live in three mirrored locations:

- `.claude/skills/<skill-name>/` — Claude Code skill
- `.agents/skills/<skill-name>/` — Universal skill (all tools)
- `.agent/skills/<skill-name>/` — Jules/Gemini skill

**Required files for a new skill:**

```text
.agents/skills/my-skill/
├── SKILL.md          ← The skill definition (required)
└── LICENSE.txt       ← MIT license (copy from any existing skill)
```

**`SKILL.md` structure:**

```markdown
# Skill Name

## Purpose
One-sentence description of what this skill does.

## When to Use
- Bullet list of triggering scenarios

## When NOT to Use
- Bullet list of cases where another skill or approach is better

## Procedure
Step-by-step instructions the agent will follow.

## Output
What the skill produces / what the user receives.
```

**Naming conventions:**

- Directory name: `kebab-case` (e.g. `accessibility-audit`)
- Invoke command: `/skill-name` (matches directory name)
- Keep skill names short and action-oriented

After adding a skill in one location, mirror it to the other two locations.

---

## Improving an Existing Skill or Workflow

Before editing:

1. Read the current file carefully end-to-end.
2. Make sure your change doesn't break the logical flow of the procedure.
3. Keep changes focused — one improvement per PR is easier to review than a batch rewrite.

For workflow files (`.agent/workflows/`), every phase should be:

- Clearly numbered
- Have explicit inputs and expected outputs
- Reference specific files or commands where applicable

---

## Reporting Issues

Use the GitHub issue templates:

- **Bug report** — for skills, workflows, or instructions that produce incorrect agent behavior
- **Feature request** — for new skills, workflows, or improvements

When reporting a bug, include:

- Which AI agent you were using (Claude Code, Copilot, etc.)
- Which skill or workflow was involved
- What the agent did vs. what you expected
- The relevant excerpt from the skill/workflow definition

---

## Pull Request Process

1. All PRs require at least one review before merging.
2. Use the PR template — it includes a checklist for common quality checks.
3. PRs that add or modify skill/workflow files should include a brief description of how the change was tested (which agent, which project).
4. PRs that change `README.md` significantly should update the table of contents if applicable.
5. **PRs that add `.md` files containing `[FILL:]` markers must update `.fill-marker-baseline`.**
   Add a new line `path/to/file.md=<count>` where count is the number of individual occurrences:

   ```bash
   grep -oh "\[FILL:" path/to/file.md | wc -l
   ```

   Use `grep -oh` (match count), **not** `grep -c` (line count). A line containing two `[FILL:` markers counts as 1 with `-c` but 2 with `-oh`. The CI script uses `rg -o` which counts individual matches, so `-c` will produce an incorrect (lower) baseline and cause CI to fail.

   Important: the baseline must reflect the **post-merge** state. If `main` has advanced since you branched, re-check the counts for any files that changed on `main` and update accordingly before asking for review.

**Branch naming:**

```text
feat/      — new skills, workflows, or capabilities
fix/       — corrections to existing content
docs/      — documentation-only changes
refactor/  — restructuring without functional change
```

---

## Style Guidelines

These mirror the rules already in the template itself:

**Markdown**

- Use `| --- | --- |` table separators (aligned pipes)
- Every fenced code block must have a language specifier (even `text` for plain text)
- Single H1 per file (`# Title`)
- Heading hierarchy must be incremental (no H3 without H2)
- Unique subheadings within a document

**Placeholders**

- Use `[FILL: description]` for values that must be customized per project
- Use `<!-- SETUP: description -->` for inline setup annotations in HTML/YAML
- Never add project-specific data to universal files — mark it with `[FILL:]` instead

**Language**

- All files in English
- Action-oriented headings (e.g. "Adding a New Skill" not "Skills")

---

Thank you for helping make this template better for every developer who uses it.
