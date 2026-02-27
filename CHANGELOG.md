# Changelog

All notable changes to the **Awesome Agentic AI Coding Template** are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.2] — 2026-02-27

### Fixed (v1.0.2)

Resolved all 13 issues identified in the second repository analysis (`docs/_analysis/REPO-ANALYSIS-2026-02-27.md`).

#### Hardcoded paths & project contamination

- Replaced hardcoded `docs/docs--recommendation-template/` paths with `[FILL:]` markers in qa-audit skills and workflow
- Synced qa-audit skill content across all 3 directories (`.claude/`, `.agents/`, `.agent/`)
- Cleaned doc-audit skill in `.claude/` — removed project-specific entries and duplicate phase block
- Genericized qa-audit workflow (`.agent/workflows/qa-audit.md`) — all 9 phases now use `[FILL:]` markers

#### New files

- Created `GEMINI.md` with `[FILL:]` markers matching `CLAUDE.md` structure
- Created `.githooks/pre-commit` and `.githooks/commit-msg` with framework-delegating logic

#### Template hygiene

- Replaced broken GIF in README with TODO comment
- Translated 5 German comments in `.repomixignore` to English
- Removed `@package.json` references from `CLAUDE.md` (template has no package.json)
- Added `<!-- SYNC: ... -->` comments to all 3 `coding-standards.md` files
- Added Windsurf/Aider/Amazon Q/Devin compatibility note to README

#### Dependency updates

- Updated pre-commit hook versions: pre-commit-hooks v4.6.0→v6.0.0, gitleaks v8.18.2→v8.30.0, markdownlint-cli2 v0.13.0→v0.21.0, shellcheck v0.10.0→v0.11.0
- Expanded `template-markers` hook exclude list for new files (`GEMINI.md`, workflow files, rule files)

#### Linting & formatting

- Fixed MD047 (missing trailing newline) in `README.md`
- Fixed MD029 (ordered list prefix) in both analysis documents — subsection lists now restart at 1
- Fixed MD036 (emphasis as heading) in `CHANGELOG.md` — converted bold lines to `####` headings
- Fixed MD032 (blank lines around lists) in `CHANGELOG.md`, `CLAUDE.md`, `GEMINI.md`, `.agent/workflows/qa-audit.md`
- Removed unsupported `allowed-tools` frontmatter from 6 `.claude/skills/*/SKILL.md` files

#### Maintenance

- Regenerated `repomix-output.xml` (150 files, ~205K tokens)

---

## [1.0.0] — 2026-01-01

### Added (v1.0.0)

#### Multi-agent configuration system

- `CLAUDE.md` — always-on project instructions for Claude Code
- `AGENTS.md` — always-on instructions for GitHub Copilot, Cursor, Codex, Kilo Code, and Jules
- `.github/copilot-instructions.md` — persistent instructions for VS Code Copilot Chat
- `.github/pull_request_template.md` — PR quality-gate checklist
- `.kilocode/rules/coding-standards.md` — Kilo Code project-level custom rules (priority 2)

#### Copilot prompt and instruction files

- `.github/prompts/new-feature.prompt.md` — structured planning before feature coding
- `.github/prompts/review-changes.prompt.md` — pre-commit rule compliance review
- `.github/instructions/docs.instructions.md` — scoped documentation rules
- `.github/instructions/qa-audit.instructions.md` — scoped QA audit instructions

#### Claude Code configuration

- `.claude/rules/coding-standards.md` — project coding standards (path-scoped)
- `.claude/rules/markdown-quality.md` — markdown quality rules (path-scoped)
- `.claude/agents/qa-reviewer.md` — Claude subagent for automated code review
- `.claude/settings.json` — Claude Code settings
- `.claude/hooks/protect-files.sh` — pre-tool-call hook to protect critical files

#### Universal skill library (15 skills)

Available in `.claude/skills/`, `.agents/skills/`, and `.agent/skills/`:

- `brainstorming` — structured ideation before building
- `systematic-debugging` — root-cause analysis methodology
- `qa-audit` — 9-phase security and robustness audit
- `doc-audit` — documentation drift detection
- `feature-delivery` — end-to-end feature workflow
- `release-readiness` — pre-release quality gate
- `hotfix` — emergency fix workflow
- `architecture-change` — ADR-gated architecture refactors
- `requesting-code-review` — structured review request
- `writing-plans` — spec-to-plan conversion
- `frontend-design` — production-grade UI implementation
- `skill-creator` — create new custom skills
- `find-skills` — discover available skills
- `using-superpowers` — session start skill discovery
- `jules-tasks` — Jules task and session management

#### Workflow procedures (9 workflows) for Jules/Gemini/Antigravity

- `doc-audit.md` — documentation drift audit
- `qa-audit.md` — quality audit with 9 phases
- `feature-delivery.md` — feature planning to docs sync
- `release-readiness.md` — pre-release verification
- `architecture-change.md` — architecture refactor procedure
- `hotfix.md` — emergency fix procedure
- `pr-analysis.md` — pull request quality review
- `post-merge-analysis.md` — post-merge verification
- `get-jules-tasks.md` — retrieve Jules task list

#### Jules automation scripts

Located in `.agent/scripts/`:

- `analyze_pr.sh` — PR analysis automation
- `fetch_gemini_reviews.py` — Gemini review fetcher
- `gh-helpers.sh` — GitHub CLI helper functions
- `jules-api.sh` — Jules API interaction helpers
- `jules-batch-review.js` — batch PR review runner
- `jules-create-prs.sh` — Jules PR creation automation
- `jules-extract-patch.js` — patch extraction utility

#### Gemini/Antigravity rules

- `.agent/rules/coding-standards.md` — always-on rules for Jules/Antigravity

#### Placeholder system

- `[FILL: ...]` convention for project-specific configuration points
- `<!-- SETUP: ... -->` for inline setup annotations

#### Community files

- `README.md` — professional marketing README
- `CONTRIBUTING.md` — contribution guidelines
- `CHANGELOG.md` — this file
- `LICENSE` — MIT license
- `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1
- `.github/ISSUE_TEMPLATE/bug_report.md` — bug report template
- `.github/ISSUE_TEMPLATE/feature_request.md` — feature request template

---

[1.0.2]: https://github.com/florian101010/awesome-agentic-AI-coding-template/compare/v1.0.0...v1.0.2
[1.0.0]: https://github.com/florian101010/awesome-agentic-AI-coding-template/releases/tag/v1.0.0
