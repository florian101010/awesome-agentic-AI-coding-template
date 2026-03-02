# Example Fully Configured Profile

## Purpose

This file shows what every agent instruction file looks like **after** all `[FILL:]` markers have been replaced. Use it as a reference when configuring the template for your own project.

The example project is **Acme Notes** — a collaborative notes platform built with TypeScript, React, and Node.js.

---

## Example Project Context

| Field | Value |
| --- | --- |
| Project name | Acme Notes |
| Description | Collaborative notes platform for product and engineering teams |
| Tech stack | TypeScript, React, Node.js, PostgreSQL |
| Test command | `npm test` |
| Lint command | `npm run lint` |
| Build command | `npm run build` |
| API gateway | `src/api/client.ts` |

---

## Filled Instruction Files

### CLAUDE.md

```markdown
# CLAUDE.md

> Project-specific rules for Claude Code. Coding detail rules are in `.claude/rules/` (path-scoped, auto-loaded).
> See @README.md for project overview.

## Project

Acme Notes — Collaborative notes platform for product and engineering teams. TypeScript, React, Node.js, PostgreSQL.

## Critical Constraints

- No runtime dependencies added without updating `package.json` and notifying the team
- All API calls must go through `src/api/client.ts` — never call fetch/axios directly
- **Git hooks** — Active via `git config core.hooksPath .githooks`. Ensure pre-commit passes before finalizing.

## Do NOT

- Use localStorage or sessionStorage — use the shared session store in `src/store/`
- Commit directly to main without a PR
- Add console.log statements to production code

## Available Scripts

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`
- Type-check: `npm run typecheck`

## After Every Change

1. Run `npm test`
2. Commit via `git commit` (hooks run automatically) with format `type(scope): description`
3. Update `docs/ARCHITECTURE.md` if a new module or pattern is introduced
```

---

### AGENTS.md

```markdown
# AGENTS.md

> Always-on rules for all AI coding agents (Copilot, Cursor, Codex, Jules, etc.).

## Project

**Acme Notes** — Collaborative notes platform for product and engineering teams.
Stack: TypeScript, React 18, Node.js 20, PostgreSQL 15, Vitest, ESLint, Prettier.

## Architecture (Must-Know)

- All API access goes through `src/api/client.ts` — no direct fetch/axios calls elsewhere
- React state lives in `src/store/` (Zustand) — no local useState for cross-component state
- Database queries go through `src/db/queries/` — no raw SQL outside that folder
- No runtime framework changes without an ADR in `docs/decisions/`
- Use repo-local hooks from `.githooks/`

## Key Files

| File/Dir | Purpose |
| --- | --- |
| `src/api/client.ts` | Shared API client — all external calls go here |
| `src/store/` | Zustand stores — cross-component state |
| `src/db/queries/` | Database query functions |
| `src/components/` | React components — presentational only |
| `src/pages/` | Route-level page components |
| `docs/decisions/` | Architecture Decision Records (ADRs) |

## Do NOT

- Call external APIs outside of `src/api/client.ts`
- Use class components — functional + hooks only
- Add `console.log` to production code
- Store secrets or credentials in source files

## Commit Format

`type(optional-scope): description`

Types: feat, fix, docs, style, refactor, test, chore, ci, perf, build, revert
```

---

### GEMINI.md

```markdown
# GEMINI.md

> Always-on rules for Google Gemini and Antigravity agents.

## Project

**Acme Notes** — Collaborative notes platform for product and engineering teams.
Stack: TypeScript, React 18, Node.js 20, PostgreSQL 15.

## Critical Rules

- All API calls through `src/api/client.ts`
- No direct database access outside `src/db/queries/`
- Tests required for every new function — run `npm test` to validate
- Commit format: `type(scope): description`

## Do NOT

- Modify `package-lock.json` manually
- Introduce new npm packages without explicit approval
- Skip running lint (`npm run lint`) before committing
```

---

### .github/copilot-instructions.md

```markdown
# Copilot Instructions

## Project Context

**Acme Notes** — Collaborative notes platform for product and engineering teams.
TypeScript, React 18, Node.js 20, PostgreSQL 15.

## Must Always

- Route all API calls through `src/api/client.ts`
- Use Zustand stores in `src/store/` for shared state
- Write Vitest tests for every new function
- Run `npm test` after any logic change
- Use `npm run lint` before committing

## Never Do

- Use localStorage or sessionStorage
- Write raw SQL outside `src/db/queries/`
- Use class-based React components
- Add `console.log` to non-test files
- Commit directly to `main`

## Key Files

| File | Purpose |
| --- | --- |
| `src/api/client.ts` | Only place for external API calls |
| `src/store/` | Zustand state management |
| `src/db/queries/` | All database queries |
| `src/components/` | Presentational components |

## Common Tasks

- Add a feature: create component in `src/components/`, add route in `src/pages/`, add state in `src/store/`
- Fix a bug: trace through `src/api/client.ts` → store → component
- Add a query: add typed function to `src/db/queries/`, test with Vitest
```

---

### .cursorrules

```text
# Acme Notes — Cursor Rules

Project: Collaborative notes platform. Stack: TypeScript, React 18, Node.js 20, PostgreSQL 15.

ALWAYS:
- Route all API calls through src/api/client.ts
- Use Zustand stores in src/store/ for shared state
- Write Vitest tests for all new functions
- Run npm test after changes to logic

NEVER:
- Use localStorage or sessionStorage
- Write raw SQL outside src/db/queries/
- Use class-based React components
- Add console.log to production code
- Commit directly to main
```

---

### .agent/rules/coding-standards.md (filled)

```markdown
---
trigger: always
---

# Coding Standards

## Architecture

- **API gateway** — All external API calls go through `src/api/client.ts`. Never call fetch/axios directly.
- **State management** — Zustand stores in `src/store/` only. No useState for cross-component state.
- **Database access** — All queries in `src/db/queries/`. No raw SQL elsewhere.

## TypeScript Rules

- Strict mode enabled — no `any` types
- Use explicit return types on all exported functions
- Prefer `interface` over `type` for object shapes
- No `as` casting except at verified system boundaries

## General Rules

- Minimal changes only — don't touch unrelated files
- No unsolicited features
- No `console.log` in production code — use the shared logger in `src/utils/logger.ts`
- Relative paths only — no leading `/` or `./`

## Git Hook Policy

- Activate repo-local hooks: `git config core.hooksPath .githooks`
- Ensure hooks are executable: `chmod +x .githooks/pre-commit .githooks/commit-msg`
- `pre-commit` must pass before final handoff
- Commit messages must follow `type(optional-scope): description`
```

---

### project-context.json

```json
{
  "project_name": "Acme Notes",
  "description": "Collaborative notes platform for product and engineering teams",
  "tech_stack": ["TypeScript", "React", "Node.js", "PostgreSQL"],
  "commands": {
    "test": "npm test",
    "lint": "npm run lint",
    "build": "npm run build",
    "typecheck": "npm run typecheck"
  },
  "key_files": {
    "api_gateway": "src/api/client.ts",
    "state_store": "src/store/",
    "db_queries": "src/db/queries/",
    "components": "src/components/"
  }
}
```

---

## Adoption Checklist

1. Copy `project-context.example.json` to `project-context.json` and fill in real values.
2. Run `/setup-repo` in Claude Code (or attach `repomix-output.xml` to your agent) to auto-fill all instruction files.
3. Verify no `[FILL:]` markers remain in core instruction files:
   ```bash
   grep -rn "\[FILL:" CLAUDE.md AGENTS.md GEMINI.md .github/copilot-instructions.md .cursorrules
   ```
4. Run `python3 scripts/template-health-report.py` to generate `docs/TEMPLATE-HEALTH.md`.
5. Run `bash scripts/check-agent-context-sync.py` to verify all agent files share consistent project metadata.
6. Run `bash scripts/check-all.sh` to confirm all checks pass.
7. Activate git hooks: `git config core.hooksPath .githooks && chmod +x .githooks/pre-commit .githooks/commit-msg`.
8. Make a test commit to confirm the `commit-msg` hook validates the conventional commit format.
9. Review remaining `[FILL:]` markers in skills and workflow files — these are intentionally left for project-specific customization.
