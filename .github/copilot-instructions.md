# Copilot Instructions

> Persistent instructions for GitHub Copilot Chat, Code Review, and Coding Agents.
> See also `AGENTS.md` (root) for the full rule set and `.agent/workflows/` for common task procedures.

<!-- SETUP: Fill in all [FILL: ...] placeholders. See README.md for the full setup guide. -->

## Project Context

**[FILL: Project Name]** — [FILL: 1-sentence description. Tech stack. Target environment.]

[FILL: Any additional context line, e.g. "No build step. No frameworks." or "TypeScript monorepo, runs on Node 22+."]

## Always Do

- [FILL: Rule 1 — e.g. "Use vanilla JS — no frameworks, no runtime npm dependencies"]
- [FILL: Rule 2 — e.g. "Keep all data in config/*.js files"]
- Use repo-local hooks via `.githooks/` (`git config core.hooksPath .githooks`) and ensure pre-commit passes before finalizing
- Use commit format `type(optional-scope): description`

## Never Do

- [FILL: Prohibition 1 — e.g. "Introduce frameworks, bundlers, or package managers"]
- [FILL: Prohibition 2 — e.g. "Use localStorage, sessionStorage, cookies, or postMessage"]
- [FILL: Prohibition 3 — e.g. "Hardcode data that belongs in config files"]

## Key Files

| File | Purpose |
| --- | --- |
| [FILL: `src/index.ts`] | [FILL: Entry point] |
| [FILL: `config/app.ts`] | [FILL: Application configuration] |
| [FILL: `docs/README.md`] | [FILL: Primary documentation] |

## Common Tasks

Agent Skills (via `/skill-name` in chat) and Prompt Files (via `/command`) are available for all common workflows:

| Task | Invoke | Details |
| --- | --- | --- |
| QA audit | `/qa-audit` skill | `.agents/skills/qa-audit/SKILL.md` — security + robustness audit |
| Documentation audit | `/doc-audit` skill | `.agents/skills/doc-audit/SKILL.md` — drift audit |
| Feature delivery | `/feature-delivery` skill | `.agents/skills/feature-delivery/SKILL.md` |
| Plan a new feature | `/new-feature` prompt | `.github/prompts/new-feature.prompt.md` — structured plan before coding |
| Review changes pre-commit | `/review-changes` prompt | `.github/prompts/review-changes.prompt.md` — rule compliance check |
| Release readiness | `/release-readiness` skill | `.agents/skills/release-readiness/SKILL.md` |
| Hotfix | `/hotfix` skill | `.agents/skills/hotfix/SKILL.md` |

## Documentation

Full docs at `docs/` — start with `README.md`.
[FILL: Add link to engineering playbook or architecture doc if applicable.]

