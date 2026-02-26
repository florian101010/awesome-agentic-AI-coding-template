# CLAUDE.md

> Project-specific rules for Claude Code. Coding detail rules are in `.claude/rules/` (path-scoped, auto-loaded).
> See @README.md for project overview and @package.json for available npm commands.

<!-- SETUP: Fill in all [FILL: ...] placeholders before using this repo. See README.md. -->

## Project

[FILL: Project name] — [FILL: 1-sentence description]. [FILL: Tech stack, e.g. "TypeScript, React, Node.js"].

## Critical Constraints

<!-- Add constraints Claude cannot infer from code alone. Examples: -->
- [FILL: Constraint 1 — e.g. "No runtime dependencies — only stdlib"]
- [FILL: Constraint 2 — e.g. "All API calls must go through the gateway module"]
- **Git hooks** — Active via `git config core.hooksPath .githooks`. Ensure pre-commit passes before finalizing.

## Do NOT

<!-- Hard prohibitions — things that would break the project if done wrong. -->
- [FILL: Prohibition 1 — e.g. "Use localStorage or sessionStorage"]
- [FILL: Prohibition 2 — e.g. "Commit directly to main without a PR"]

## Available npm Scripts

@package.json

## After Every Change

1. Run `[FILL: test command, e.g. npm test]`
2. Commit via `git commit` (hooks run automatically) with format `type(scope): description`
3. [FILL: Any additional post-change steps specific to your project]

## Context & Compaction

When compacting, always preserve: the list of modified files, any pending test results, the current task state, and the active branch name.
