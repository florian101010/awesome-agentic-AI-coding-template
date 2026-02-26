# AGENTS.md

> Agent instructions for AI coding tools (OpenAI Codex, GitHub Copilot, Cursor, Kilo Code, Google Jules).
> For Claude Code see `CLAUDE.md`. For Kilo Code project rules see `.kilocode/rules/`. For Gemini/Antigravity see `.agent/rules/`.

<!-- SETUP: Fill in all [FILL: ...] placeholders. See README.md for the full setup guide. -->

## Project Overview

**[FILL: Project Name]** — [FILL: 1-2 sentence project description. What does it do? Who uses it?]

## Architecture (Must-Know)

<!-- Keep only what agents cannot infer from the code. Remove or replace examples below. -->

- **[FILL: Key architectural constraint 1]** — e.g. "No runtime frameworks, vanilla JS only"
- **[FILL: Key architectural constraint 2]** — e.g. "Config-driven: all data in config/ files, never hardcode in templates"
- **[FILL: Key architectural constraint 3]** — e.g. "Touch-first: runs in iOS/Android WebView, all interactions are touch gestures"
- **Repo-local Git hooks** — Use `.githooks/` via `git config core.hooksPath .githooks` and keep hooks executable

## File Structure

```text
[FILL: Add your project's key file structure here.
Only include files/folders that agents must know about to work effectively.
Example:

src/
  index.ts              ← Entry point
  api/                  ← API layer
  components/           ← UI components

config/
  app-config.ts         ← Application configuration

tests/
  *.test.ts             ← Unit tests

docs/
  README.md             ← Primary documentation
]
```

## Coding Rules

### General

1. **[FILL: Rule 1]** — e.g. "No runtime frameworks"
2. **[FILL: Rule 2]** — e.g. "Config as Single Source of Truth"
3. **Minimal changes** — Only touch files necessary for the task
4. **No unsolicited features** — Don't add functionality the user didn't ask for

### AI Execution & Orchestration

1. **No hanging bash loops** — Never use fire-and-forget bash scripts for multi-step iteration or orchestration.
2. **Agent-Orchestrated Concurrency** — For batch tasks, retrieve the list of targets via a native tool, then have the agent iterate with individual tool calls.
3. **MCP Server Tools Over CLI** — Always prioritize native MCP integrations (e.g., Github MCP Server) over arbitrary CLI commands.
4. **Strict Subprocess Timeouts** — Every CLI command via `child_process` must have a strict timeout (e.g., `{ timeout: 10000 }`).

### Documentation Hygiene

1. **Table Style** — Use `| --- | --- |` separator style for all tables.
2. **Fenced Code Language** — Every fenced code block must include a language specifier.
3. **Heading Quality** — Single H1 per file (MD025), logical increments (MD001), unique subheadings within document (MD024).

## Immutable Contract — NEVER CHANGE

<!-- Document any IDs, keys, or values that are used externally and must never change. -->
<!-- If none: remove this section. -->

[FILL: e.g.
- `api-variant-id-1` — used in deeplinks
- `SCHEMA_VERSION=3` — written to stored data
]

## Common Tasks

Agent Skills (via `/skill-name` in chat) and Prompt Files (via `/command`) are available for common workflows:

| Task | Invoke | Details |
| --- | --- | --- |
| QA audit | `/qa-audit` skill | `.agents/skills/qa-audit/SKILL.md` |
| Documentation audit | `/doc-audit` skill | `.agents/skills/doc-audit/SKILL.md` |
| Feature delivery | `/feature-delivery` skill | `.agents/skills/feature-delivery/SKILL.md` |
| Plan a new feature | `/new-feature` prompt | `.github/prompts/new-feature.prompt.md` |
| Review changes pre-commit | `/review-changes` prompt | `.github/prompts/review-changes.prompt.md` |
| Release readiness | `/release-readiness` skill | `.agents/skills/release-readiness/SKILL.md` |
| Hotfix | `/hotfix` skill | `.agents/skills/hotfix/SKILL.md` |

## After Every Change

1. Run `[FILL: your test command, e.g. npm test]`
2. Commit via `git commit` (hooks run automatically) with format `type(scope): description`
3. [FILL: Any additional verification steps specific to your project]

## Documentation

| Doc | What it covers |
| --- | --- |
| [README.md](README.md) | Project overview and quick start |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Template architecture and design decisions |
| [docs/CUSTOMIZATION-GUIDE.md](docs/CUSTOMIZATION-GUIDE.md) | How to fill every `[FILL:]` marker |
| [docs/SKILLS-CATALOG.md](docs/SKILLS-CATALOG.md) | All available skills and how to invoke them |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
[FILL: Add links to project-specific docs, e.g. ENGINEERING-PLAYBOOK.md, API-REFERENCE.md]
