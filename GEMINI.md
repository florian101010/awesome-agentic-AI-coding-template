# GEMINI.md

> Project-specific rules for Google Gemini CLI / Antigravity. Shared rules are in `.agent/rules/` (auto-loaded).
> See README.md for project overview.

<!-- SETUP: Fill in all [FILL: ...] placeholders before using this repo. See README.md. -->

## Project

[FILL: Project name] — [FILL: 1-sentence description]. [FILL: Tech stack, e.g. "TypeScript, React, Node.js"].

## Critical Constraints

<!-- Add constraints Gemini cannot infer from code alone. Examples: -->
- [FILL: Constraint 1 — e.g. "No runtime dependencies — only stdlib"]
- [FILL: Constraint 2 — e.g. "All API calls must go through the gateway module"]
- **Git hooks** — Active via `git config core.hooksPath .githooks`. Ensure pre-commit passes before finalizing.

## Do NOT

<!-- Hard prohibitions — things that would break the project if done wrong. -->
- [FILL: Prohibition 1 — e.g. "Use localStorage or sessionStorage"]
- [FILL: Prohibition 2 — e.g. "Commit directly to main without a PR"]

## Available Scripts

[FILL: List your key build/test/lint commands here, e.g.:

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

]

## After Every Change

1. Run `[FILL: test command, e.g. npm test]`
2. Commit via `git commit` (hooks run automatically) with format `type(scope): description`
3. [FILL: Any additional post-change steps specific to your project]
