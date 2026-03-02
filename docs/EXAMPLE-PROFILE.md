# Example Fully Configured Profile

## Purpose

This file demonstrates a fully configured profile for a TypeScript + Node.js project so teams can quickly understand what a completed setup looks like.

## Example Project Context

| Field | Example value |
| --- | --- |
| Project name | Acme Notes |
| Description | Collaborative notes platform for product and engineering teams |
| Tech stack | TypeScript, React, Node.js |
| Test command | `npm test` |
| Lint command | `npm run lint` |
| Build command | `npm run build` |

## Example Filled Snippets

### AGENTS.md (project overview + key constraints)

```md
## Project Overview

**Acme Notes** — Collaborative notes platform for product and engineering teams.

## Architecture (Must-Know)

- **All API access goes through `src/api/client.ts`**
- **No runtime framework changes without an ADR**
- **Use repo-local hooks from `.githooks/`**
```

### CLAUDE.md / GEMINI.md (core identity line)

```md
Acme Notes — Collaborative notes platform for product and engineering teams. TypeScript, React, Node.js.
```

### Copilot Instructions (must-do example)

```md
## Must Always

- Use `npm test` for test validation after code changes.
- Keep API calls in the shared API client.
```

## Adoption Checklist

1. Copy `project-context.example.json` to `project-context.json` and set real values.
2. Run `bash setup.sh` to populate major placeholders.
3. Run `python3 scripts/template-health-report.py`.
4. Run `bash scripts/check-all.sh`.
5. Resolve remaining placeholders intentionally left for project-specific docs.
