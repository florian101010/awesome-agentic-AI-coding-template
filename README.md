# Awesome Agentic AI Coding Template

![Agentic AI Template Demo](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExMDlxcmMzaWZpaGN6MnpuNWQ2eHNzNnM1dWJ5b3RteXk3Y2tveW04OCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/dxmXDNIP4nrIpw7VDP/giphy.gif)

> **A production-ready, multi-agent AI coding setup you can drop into any project.**
> Stop configuring AI tools from scratch. Start from a battle-tested baseline that makes every coding agent smarter, safer, and more consistent from day one.

[👉 **Click here to generate your project from this template** 👈](https://github.com/florian101010/awesome-agentic-AI-coding-template/generate) | [**Jump to Quick Start 🚀**](#quick-start)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![GitHub stars](https://img.shields.io/github/stars/florian101010/awesome-agentic-AI-coding-template?style=social)](https://github.com/florian101010/awesome-agentic-AI-coding-template/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/florian101010/awesome-agentic-AI-coding-template?style=social)](https://github.com/florian101010/awesome-agentic-AI-coding-template/network/members)
[![GitHub last commit](https://img.shields.io/github/last-commit/florian101010/awesome-agentic-AI-coding-template)](https://github.com/florian101010/awesome-agentic-AI-coding-template/commits/main)

---

## Why This Template Exists

Most developers configure their AI coding tools ad-hoc — a few lines in a `CLAUDE.md`, maybe a Copilot instruction file. The result: agents that hallucinate project conventions, make unsafe mutations, break existing patterns, and need constant correction.

This template encodes **production-ready agentic development practices** into a structured, multi-layered instruction system. It covers:

- **Consistent coding standards** enforced across all agents
- **Security-first rules** (XSS guards, escaping, forbidden APIs)
- **Safe AI orchestration patterns** (no hanging loops, MCP-first, strict timeouts)
- **Pre-built skills and workflows** for the most common engineering tasks
- **Documentation drift prevention** built in from the start
- **Git hook integration** for automated quality gates

Clone it, fill in your project details, and every AI tool working on your codebase will follow the same high-quality standards.

### Who is this for?

Whether you are a solo indie hacker using Cursor, or an enterprise team orchestrating GitHub Copilot and Google Jules, this template standardizes your AI interactions.

---

## Compatible AI Coding Agents

This template provides optimized configurations for all major AI coding tools:

| Agent | Config files | Key capability |
| --- | --- | --- |
| **Claude Code** (Anthropic) | `CLAUDE.md`, `.claude/rules/`, `.claude/agents/`, `.claude/skills/` | Full skill system, path-scoped rules, subagents, hooks |
| **GitHub Copilot** (VS Code) | `.github/copilot-instructions.md`, `.github/prompts/`, `.github/instructions/` | Persistent instructions, prompt files, scoped instructions |
| **Cursor** | `AGENTS.md` | Project-wide context via rules file |
| **OpenAI Codex** | `AGENTS.md` | Project-wide context |
| **Kilo Code** | `AGENTS.md`, `.kilocode/rules/` | AGENTS.md context + dedicated project rules (priority 2) |
| **Google Jules** | `AGENTS.md` (read natively), `README.md` (env setup fallback) | Autonomous async task execution; Jules reads `AGENTS.md` automatically on every task |
| **Google Gemini / Antigravity** | `GEMINI.md`, `.agent/rules/`, `.agent/workflows/`, `.agent/skills/` | Always-on rules, reusable workflow definitions, skill library |

> **Other tools** — Windsurf, Aider, Amazon Q Developer, and Devin can leverage `AGENTS.md` (widely supported) plus `.agent/` rules and workflows. See [docs/CUSTOMIZATION-GUIDE.md](docs/CUSTOMIZATION-GUIDE.md) for adaptation tips.

One template, every major agent, zero duplication.

---

## What's Inside

```text
.
├── CLAUDE.md                          ← Claude Code — always-on project instructions
├── AGENTS.md                          ← Copilot / Cursor / Codex / Jules — always-on
│
├── .github/
│   ├── copilot-instructions.md        ← VS Code Copilot Chat — persistent instructions
│   ├── prompts/
│   │   ├── new-feature.prompt.md      ← /new-feature — structured planning before coding
│   │   └── review-changes.prompt.md   ← /review-changes — pre-commit rule compliance
│   ├── instructions/
│   │   ├── docs.instructions.md       ← Scoped: docs/**/*.md — documentation rules
│   │   └── qa-audit.instructions.md   ← Scoped: audit files — QA audit process
│   └── pull_request_template.md       ← PR quality-gate checklist
│
├── .claude/
│   ├── rules/                         ← Path-scoped always-on rules for Claude
│   │   ├── coding-standards.md
│   │   └── markdown-quality.md
│   ├── agents/
│   │   └── qa-reviewer.md             ← Claude subagent: automated code reviewer
│   └── skills/                        ← Claude skill library (16 skills)
│       ├── brainstorming/
│       ├── doc-audit/
│       ├── feature-delivery/
│       ├── frontend-design/
│       ├── hotfix/
│       ├── qa-audit/
│       ├── release-readiness/
│       ├── requesting-code-review/
│       ├── skill-creator/
│       ├── systematic-debugging/
│       ├── writing-plans/
│       └── ...
│
├── .agents/skills/                    ← Universal skill library (16 skills, works with all tools)
│
├── .kilocode/
│   └── rules/
│       └── coding-standards.md         ← Kilo Code project rules (priority 2, above AGENTS.md)
│
├── .agent/
│   ├── rules/                         ← Gemini/Antigravity/Jules always-on rules
│   ├── skills/                        ← Jules/Gemini skill library
│   ├── workflows/                     ← Reusable workflow procedures
│   │   ├── doc-audit.md
│   │   ├── feature-delivery.md
│   │   ├── qa-audit.md
│   │   ├── release-readiness.md
│   │   ├── architecture-change.md
│   │   ├── hotfix.md
│   │   └── pr-analysis.md
│   └── scripts/                       ← Jules API helpers, PR analysis automation
│
├── scripts/                           ← Template quality gate tools
│   ├── check-fill-markers.sh          ← Detect [FILL:] placeholder regressions
│   ├── check-agent-context-sync.py    ← Verify project-context.json is in sync across agent files
│   ├── template-health-report.py      ← Generate docs/TEMPLATE-HEALTH.md metrics
│   └── check-all.sh                   ← Run all checks in one command
│
├── project-context.example.json       ← Optional: canonical project metadata for sync checks
│
└── docs/
    ├── ARCHITECTURE.md                       ← Why the template is structured the way it is
    ├── CUSTOMIZATION-GUIDE.md                ← How to fill every [FILL:] marker, file by file
    ├── SKILLS-CATALOG.md                     ← Every skill: what it does, when to use it, invocation
    ├── TEMPLATE-HEALTH.md                    ← Auto-generated: placeholder counts and skill stats
    ├── EXAMPLE-PROFILE.md                    ← Reference: what a fully configured setup looks like
    └── ai-coding-agents-best-practices.md    ← Full reference: Claude Code, Copilot, Kilo Code, Antigravity
```

---

## Quick Start

### Option A — Use as GitHub Template

Click **"Use this template"** at the top right of this repository, or click the link below to generate it instantly:

[👉 **Click here to generate your project from this template** 👈](https://github.com/florian101010/awesome-agentic-AI-coding-template/generate)

### Option B — Clone and Copy

```bash
git clone https://github.com/florian101010/awesome-agentic-AI-coding-template.git
cp -r awesome-agentic-AI-coding-template/. your-project/
rm -rf your-project/.git
```

### Configure (2 minutes with setup script)

Run the interactive setup script to populate the most common `[FILL:]` markers automatically:

```bash
bash setup.sh
```

The script prompts for your project name, description, tech stack, test/lint/build commands, constraints, and prohibitions — then writes them into `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, and `.github/copilot-instructions.md`. It also offers to activate git hooks at the end.

### Configure (manual — 5 minutes)

**Step 1 — Find all placeholders.** Every customization point is marked with `[FILL: ...]`:

```bash
grep -rn "\[FILL:" . --include="*.md" | grep -v README
```

**Step 2 — Fill in the most important files:**

| File | What to provide |
| --- | --- |
| `CLAUDE.md` | Project name, key constraints, prohibited patterns, test command |
| `AGENTS.md` | Project name, architecture overview, file structure |
| `.github/copilot-instructions.md` | Always-do / never-do rules, key file table |
| `.claude/agents/qa-reviewer.md` | Project-specific review checklist items |
| `.agent/rules/coding-standards.md` | Architecture constraints, stack-specific rules |

**Step 3 — Remove what you don't need.** Sections like "Immutable Contract" or "Layout Constraints" are designed to be deleted for projects that don't need them.

> **Note:** The `[FILL: e.g. "npm test"]` placeholders in agent files refer to *your* project's test commands. This template ships no runtime code — fill in the commands that match your stack (e.g. `npm test`, `pytest`, `cargo test`).

**Step 4 — Activate Git hooks** (optional but recommended):

```bash
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit .githooks/commit-msg
```

**Step 5 — Set up secrets** (required for Jules AI scripts):

```bash
cp .env.example .env
# Then edit .env and add your JULES_API_KEY
```

The `.env.example` documents every variable the scripts expect. `.env` is git-ignored — never commit real keys.

Done. Your AI agents now operate with full project context.

---

## Pre-built Skills

Every skill is ready to invoke. Universal skills need no customization; project-specific ones have `[FILL:]` markers.

| Skill | Invoke | What it does |
| --- | --- | --- |
| **Brainstorming** | `/brainstorming` | Structured ideation — explores user intent and constraints before building |
| **Systematic Debugging** | `/systematic-debugging` | Root-cause analysis — never guess, always trace |
| **QA Audit** | `/qa-audit` | 9-phase security + robustness audit: XSS, rule compliance, race conditions |
| **Doc Audit** | `/doc-audit` | Documentation drift detection across all instruction files and project docs |
| **Feature Delivery** | `/feature-delivery` | End-to-end feature workflow: planning → implementation → QA → docs sync |
| **Release Readiness** | `/release-readiness` | Pre-release quality gate with automated + manual checks |
| **Hotfix** | `/hotfix` | Emergency fix workflow with risk assessment |
| **Requesting Code Review** | `/requesting-code-review` | Structured review request with context |
| **Writing Plans** | `/writing-plans` | Spec-to-plan conversion before any code is written |
| **Frontend Design** | `/frontend-design` | Production-grade UI components — avoids generic AI aesthetics |
| **Architecture Change** | `/architecture-change` | Controlled architecture refactor with ADR requirement |
| **Skill Creator** | `/skill-creator` | Create new custom skills for your project |
| **Find Skills** | `/find-skills` | Discover all available skills |
| **Using Superpowers** | `/using-superpowers` | Skill discovery on session start |

<!-- TODO: Add a demo recording at docs/assets/qa-audit-demo.gif and uncomment the image below -->
<!-- ![QA Audit Skill in Action](docs/assets/qa-audit-demo.gif) -->

---

## Pre-built Workflows

Workflows are detailed, multi-phase procedures that agents follow step by step. Unlike skills (invoked interactively), workflows are loaded by agents working through a structured task.

| Workflow | Purpose |
| --- | --- |
| `doc-audit.md` | Comprehensive docs drift audit across all layers |
| `qa-audit.md` | Full-scope quality audit with 9 structured phases |
| `feature-delivery.md` | Feature planning → implementation → QA → docs sync |
| `release-readiness.md` | Pre-release quality gate |
| `architecture-change.md` | ADR-gated architecture refactors |
| `hotfix.md` | Emergency fix with risk assessment |
| `pr-analysis.md` | Pull request quality review |
| `post-merge-analysis.md` | Post-merge verification |

---

## Universal Rules Baked In

These rules are active for all agents on day one — no setup required.

### AI Orchestration Safety

- No hanging bash loops — agents iterate with individual tool calls
- MCP Server Tools over raw CLI calls (GitHub, databases, APIs)
- Every subprocess call has a strict timeout (`{ timeout: 10000 }`)
- No `eval()`, `document.write()`, or stateful browser APIs

### Code Quality

- Config files get a structured header comment explaining their schema
- Code comments in English, always
- UTF-8 without BOM on all files

### Documentation Hygiene

- Markdown tables: aligned `| --- | --- |` separator style
- Every fenced code block includes a language specifier
- Single H1 per file, logical heading hierarchy, unique subheadings
- No duplicate subheadings within a document

### Git Discipline

- Repo-local hooks via `.githooks/`
- Commit format enforced: `type(optional-scope): description`
- Pre-commit quality gates before every commit

---

## The `[FILL:]` System

All project-specific content uses a consistent placeholder convention:

```text
[FILL: project name]
[FILL: describe your tech stack constraints here]
[FILL: e.g. "npm test" or "pytest" or "cargo test"]
```

This makes it trivially easy to scan for unfinished configuration:

```bash
grep -rn "\[FILL:" . --include="*.md"
```

Inline setup annotations use a different marker so they're visually distinct:

```html
<!-- SETUP: Replace this section with your project's file structure -->
```

---

## Design Principles

**1. Multi-layered** — Each AI tool gets its own config file in its native format. Claude reads `CLAUDE.md` and `.claude/`; Copilot reads `.github/copilot-instructions.md`; Jules reads `AGENTS.md` natively; Antigravity reads `.agent/`. One source of truth, delivered in every dialect.

**2. Universal + project-specific** — Universal rules (security, orchestration, markdown quality) ship ready-to-use. Project-specific rules are clearly marked with `[FILL: ...]` and isolated from the universal content.

**3. Prevention over correction** — Rules are designed to stop agents from making dangerous changes — not to catch mistakes after the fact. Security guards and forbidden patterns are enforced upfront.

**4. Drift-free** — Documentation drift is a leading cause of agent misbehavior. The doc-audit skill and workflow track every file that must stay in sync and surface drift proactively.

**5. Skill-based** — Complex multi-step tasks (audits, feature delivery, debugging) are codified as invocable skills. Skills are reusable, composable, and version-controlled alongside your code.

---

## Documentation

| Doc | What it covers |
| --- | --- |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Why the template is structured the way it is — design decisions, directory map, layering principles |
| [CUSTOMIZATION-GUIDE.md](docs/CUSTOMIZATION-GUIDE.md) | How to fill every `[FILL:]` marker, file by file, with good/bad examples |
| [SKILLS-CATALOG.md](docs/SKILLS-CATALOG.md) | Every skill: what it does, when to invoke it, which agents support it |
| [ai-coding-agents-best-practices.md](docs/ai-coding-agents-best-practices.md) | Deep reference guide for Claude Code, Copilot, Kilo Code, and Antigravity |

---

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Good contribution ideas:

- New universal skills (performance auditing, accessibility checking, etc.)
- Agent-specific optimizations as new tools emerge
- Improved workflow definitions
- Bug fixes and clarity improvements to existing skills

---

## License

MIT — see [LICENSE](LICENSE).

---

## Acknowledgments

This template builds on top of the work of the teams and individuals behind these tools and projects:

**AI coding agents:**

| Tool | Repo / Docs |
| --- | --- |
| Claude Code (Anthropic) | [github.com/anthropics/claude-code](https://github.com/anthropics/claude-code) |
| GitHub Copilot (Microsoft) | [docs.github.com/copilot](https://docs.github.com/en/copilot) |
| Google Jules | [jules.google/docs](https://jules.google/docs) |
| Google Gemini / Antigravity | [github.com/google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) |
| Cursor | [cursor.com](https://cursor.com) |
| OpenAI Codex | [platform.openai.com/docs/codex](https://platform.openai.com/docs) |
| Kilo Code | [github.com/Kilo-Org/kilocode](https://github.com/Kilo-Org/kilocode) |

**Skills & standards:**

| Project | What it contributed |
| --- | --- |
| [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent (@obra) | `using-superpowers`, `find-skills`, `systematic-debugging` skills |
| [skills.sh](https://skills.sh) | `frontend-design`, `skill-creator` skills + the skills marketplace ecosystem |
| [Agent Skills Open Standard](https://agentskills.io) | The cross-agent `SKILL.md` format used throughout |

---

**Stop configuring. Start building.**

*Clone once. Use everywhere.*

![Start building](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNDJicXNhcXA0NmlrdzFid3p4M3A0NG5sbW5wbW03ZGF1ZjZneXc3YyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/JqmupuTVZYaQX5s094/giphy.gif)
