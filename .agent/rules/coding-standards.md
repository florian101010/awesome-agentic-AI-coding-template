---
trigger: always
---

# Coding Standards

<!-- SYNC: Keep in sync with .claude/rules/coding-standards.md and .kilocode/rules/coding-standards.md -->
<!-- SETUP: Fill in all [FILL: ...] placeholders to match your project. Remove sections that don't apply. -->

## Architecture

- **[FILL: Key architectural constraint 1]** — e.g. "Config-driven: all data in `config/*.js` (IIFE + Object.freeze)"
- **[FILL: Key architectural constraint 2]** — e.g. "Vanilla HTML/CSS/JS only — no frameworks, no build step"
- **[FILL: Key architectural constraint 3]** — e.g. "Runs in iOS WKWebView and Android WebView — touch-first"

## [FILL: Language/Framework-Specific Rules]

<!-- Add mandatory rules specific to your stack, e.g. CSS touch rules, JS IIFE pattern, etc. -->

## General Rules

- Minimal changes only — don't touch unrelated files
- No unsolicited features
- **[FILL: Project Rule 1]** — e.g. "No runtime frameworks, no CDN imports"
- **[FILL: Project Rule 2]** — e.g. "Relative paths only — no leading `/` or `./`"
- **[FILL: Immutable contract]** — e.g. "Do NOT change binding variant IDs listed in AGENTS.md"

## Git Hook Policy

- Activate repo-local hooks: `git config core.hooksPath .githooks`
- Ensure hooks are executable: `chmod +x .githooks/pre-commit .githooks/commit-msg`
- `pre-commit` must pass before final handoff
- Commit messages must follow `type(optional-scope): description`

## Markdown Quality

- **Tables:** Use simplified `| --- | --- |` separator style for consistent alignment.
- **Code Blocks:** Always include a language specifier (e.g., `text`, `js`, `html`, `css`).
- **Headings:** Single H1 per file, logical hierarchy, and unique subheadings.

## Documentation & Comments

- Config files should have a **JSDoc-style block comment** at the top explaining the schema
- Use `/* ... */` block comments for section headers and multi-line explanations
- Use `//` inline comments sparingly — only where intent is non-obvious
- Keep all code-level comments in **English**
- When adding a new config field, update the file-top comment to document it
