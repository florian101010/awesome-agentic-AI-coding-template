# Changelog

All notable changes to the **Awesome Agentic AI Coding Template** are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-01-01

### Added (v1.0.0)

**Multi-agent configuration system**
- `CLAUDE.md` — always-on project instructions for Claude Code
- `AGENTS.md` — always-on instructions for GitHub Copilot, Cursor, Codex, Kilo Code, and Jules
- `.github/copilot-instructions.md` — persistent instructions for VS Code Copilot Chat
- `.github/pull_request_template.md` — PR quality-gate checklist
- `.kilocode/rules/coding-standards.md` — Kilo Code project-level custom rules (priority 2)

**Copilot prompt and instruction files**
- `.github/prompts/new-feature.prompt.md` — structured planning before feature coding
- `.github/prompts/review-changes.prompt.md` — pre-commit rule compliance review
- `.github/instructions/docs.instructions.md` — scoped documentation rules
- `.github/instructions/qa-audit.instructions.md` — scoped QA audit instructions

**Claude Code configuration**
- `.claude/rules/coding-standards.md` — project coding standards (path-scoped)
- `.claude/rules/markdown-quality.md` — markdown quality rules (path-scoped)
- `.claude/agents/qa-reviewer.md` — Claude subagent for automated code review
- `.claude/settings.json` — Claude Code settings
- `.claude/hooks/protect-files.sh` — pre-tool-call hook to protect critical files

**Universal skill library (15 skills)** — available in `.claude/skills/`, `.agents/skills/`, and `.agent/skills/`
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

**Workflow procedures (9 workflows) for Jules/Gemini/Antigravity**
- `doc-audit.md` — documentation drift audit
- `qa-audit.md` — quality audit with 9 phases
- `feature-delivery.md` — feature planning to docs sync
- `release-readiness.md` — pre-release verification
- `architecture-change.md` — architecture refactor procedure
- `hotfix.md` — emergency fix procedure
- `pr-analysis.md` — pull request quality review
- `post-merge-analysis.md` — post-merge verification
- `get-jules-tasks.md` — retrieve Jules task list

**Jules automation scripts** in `.agent/scripts/`
- `analyze_pr.sh` — PR analysis automation
- `fetch_gemini_reviews.py` — Gemini review fetcher
- `gh-helpers.sh` — GitHub CLI helper functions
- `jules-api.sh` — Jules API interaction helpers
- `jules-batch-review.js` — batch PR review runner
- `jules-create-prs.sh` — Jules PR creation automation
- `jules-extract-patch.js` — patch extraction utility

**Gemini/Antigravity rules**
- `.agent/rules/coding-standards.md` — always-on rules for Jules/Antigravity

**Placeholder system**
- `[FILL: ...]` convention for project-specific configuration points
- `<!-- SETUP: ... -->` for inline setup annotations

**Community files**
- `README.md` — professional marketing README
- `CONTRIBUTING.md` — contribution guidelines
- `CHANGELOG.md` — this file
- `LICENSE` — MIT license
- `CODE_OF_CONDUCT.md` — Contributor Covenant v2.1
- `.github/ISSUE_TEMPLATE/bug_report.md` — bug report template
- `.github/ISSUE_TEMPLATE/feature_request.md` — feature request template

---

[1.0.0]: https://github.com/florian101010/awesome-agentic-AI-coding-template/releases/tag/v1.0.0
