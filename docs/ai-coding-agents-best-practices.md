# AI Coding Agents — Best Practices & Optimales Setup

> Umfassender Guide für Claude Code, GitHub Copilot, Kilo Code, Google Antigravity/Jules und weitere AI Coding Agents (Stand: Februar 2026). Quellen: [code.claude.com/docs](https://code.claude.com/docs/en/overview), [kilo.ai/docs](https://kilo.ai/docs), [code.visualstudio.com/docs/copilot](https://code.visualstudio.com/docs/copilot/customization/overview).

**Hauptfokus:** Claude Code (Sektionen 0–17) · GitHub Copilot (Sektion 18) · Kilo Code (Sektion 19)

---

## Inhaltsverzeichnis

0. [Quick-Start: Neues Repo in 15 Minuten](#0-quick-start-neues-repo-in-15-minuten)
1. [Memory-Hierarchie](#1-memory-hierarchie)
2. [CLAUDE.md — Die Hauptdatei](#2-claudemd--die-hauptdatei)
3. [`.claude/rules/` — Modulare Regeln](#3-clauderules--modulare-regeln)
4. [`.claude/skills/` — On-Demand-Wissen](#4-claudeskills--on-demand-wissen)
5. [`.claude/commands/` — Slash Commands](#5-claudecommands--slash-commands)
6. [`.claude/agents/` — Custom Subagents](#6-claudeagents--custom-subagents)
7. [`.claude/hooks/` — Deterministische Hooks](#7-claudehooks--deterministische-hooks)
8. [Auto Memory](#8-auto-memory)
9. [`@`-Import-Syntax](#9-import-syntax)
10. [CLAUDE.local.md — Persönliche Overrides](#10-claudelocalmd--persönliche-overrides)
11. [Anti-Patterns & häufige Fehler](#11-anti-patterns--häufige-fehler)
12. [Optimale Verzeichnisstruktur (exemplarisch)](#12-optimale-verzeichnisstruktur-exemplarisch)
13. [Checkliste: CLAUDE.md Audit](#13-checkliste-claudemd-audit)
14. [Agent Skills Open Standard — Plattformvergleich](#14-agent-skills-open-standard--plattformvergleich)
15. [MCP-Server — Model Context Protocol](#15-mcp-server--model-context-protocol)
16. [Permissions & `settings.json`](#16-permissions--settingsjson)
17. [Multi-Root Workspaces & Monorepos](#17-multi-root-workspaces--monorepos)
18. [GitHub Copilot in VS Code — Optimales Setup](#18-github-copilot-in-vs-code--optimales-setup)
19. [Kilo Code — Optimales Setup](#19-kilo-code--optimales-setup)

---

## 0. Quick-Start: Neues Repo in 15 Minuten

Diese Schritt-für-Schritt-Anleitung bringt ein leeres Repo auf ein vollständiges Claude Code Setup. Die einzelnen Features werden in den nachfolgenden Sektionen im Detail erklärt.

### Schritt 1: CLAUDE.md erzeugen

```bash
# Option A: Claude generiert eine Starter-Datei basierend auf der Codebase
/init

# Option B: Manuell erstellen (empfohlen für volle Kontrolle)
touch CLAUDE.md
```

Minimales Starter-Template (anpassen!):

```markdown
# Project

[Projektname] — [1-Satz-Beschreibung]. [Sprache/Stack].

## Critical Constraints

- [Constraint 1 die Claude nicht erraten kann]
- [Constraint 2]

## Commands

- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Do NOT

- [Verbot 1]
- [Verbot 2]

@package.json
```

**Ziel:** 50–120 Zeilen. Alles was Claude nicht selbst aus dem Code ablesen kann.

### Schritt 2: Repo-lokale Git-Hooks (optional)

```bash
mkdir -p .githooks
# Hooks erstellen (pre-commit, commit-msg, etc.)
git config core.hooksPath .githooks
chmod +x .githooks/*
```

In CLAUDE.md dokumentieren:

```markdown
- Activate hooks: `git config core.hooksPath .githooks`
```

### Schritt 3: Modulare Rules anlegen

```bash
mkdir -p .claude/rules
```

Erstelle pfad-spezifische Regeln für wiederkehrende Standards:

```markdown
<!-- .claude/rules/testing.md -->
---
paths: ["**/*.test.*", "**/*.spec.*"]
---

# Testing Standards

- Use `describe/it` blocks with descriptive names
- One assertion per test (where practical)
- Arrange-Act-Assert pattern
```

### Schritt 4: Skills installieren

```bash
# Universelle Basis-Skills (empfohlen):
npx skills add vercel-labs/skills --skill find-skills --copy -a claude-code -y
npx skills add anthropics/skills --skill frontend-design --skill skill-creator --copy -a claude-code -y
npx skills add obra/superpowers --skill brainstorming --skill writing-plans --skill systematic-debugging --skill requesting-code-review --skill using-superpowers --copy -a claude-code -y
```

### Schritt 5: Slash Commands erstellen

```bash
mkdir -p .claude/commands
```

Für **Aktions-Workflows** (Deploy, Hotfix, Release) unbedingt `disable-model-invocation: true` setzen — sonst kann Claude den Workflow automatisch und unbeabsichtigt auslösen:

```markdown
<!-- .claude/commands/deploy.md -->
---
description: Deploy the application after tests
disable-model-invocation: true
---

Deploy the application:

1. Run tests: `npm test`
2. Build: `npm run build`
3. If all green, deploy with: `npm run deploy`
4. Verify the deployment is healthy
```

Aufruf: `/deploy`

> **Faustregel:** `disable-model-invocation: true` auf alle Workflows mit Seiteneffekten (Deploy, Commit, Hotfix, Release). Nur weglassen bei reinen Informations- oder Analyse-Commands.

### Schritt 6: Deterministische Hooks einrichten

```bash
mkdir -p .claude/hooks
```

Claude kann Hooks auch selbst schreiben:

```text
Write a hook that runs eslint after every file edit
Write a hook that blocks writes to the migrations folder
```

Oder interaktiv: `/hooks`

> **WICHTIG:** Ein Hook-Script ohne Registrierung in `.claude/settings.json` ist **Dead Code** — er wird niemals ausgeführt. Nach dem Erstellen eines Hooks muss er explizit registriert werden:

```json
// .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }]
      }
    ]
  }
}
```

Details: [Section 7 — Hooks](#7-claudehooks--deterministische-hooks)

### Schritt 7: MCP-Server konfigurieren

```bash
# GitHub-Integration (erfordert gh CLI):
claude mcp add github -- gh copilot mcp

# Filesystem-Server (z.B. für Docs außerhalb des Repos):
claude mcp add filesystem -- npx @anthropic/mcp-filesystem /path/to/docs

# Postgres-Anbindung:
claude mcp add postgres -- npx @anthropic/mcp-postgres $DATABASE_URL
```

Details: [Section 15 — MCP-Server](#15-mcp-server--model-context-protocol)

### Schritt 8: Permissions konfigurieren

```text
# In Claude Code:
/permissions

# Typische Einstellungen:
Allow: Bash(npm test), Bash(npm run lint), Bash(git *)
Deny: Bash(rm -rf *), Bash(curl *)
```

Details: [Section 16 — Permissions](#16-permissions--settingsjson)

### Schritt 9: Multi-Agent-Support (optional)

Wenn andere AI-Tools das Repo nutzen (Copilot, Codex, Gemini, Cursor):

```bash
# AGENTS.md für OpenAI Codex / Gemini CLI / Cursor
touch AGENTS.md

# Skills für alle Tools verfügbar machen
mkdir -p .agents/skills
cp -r .claude/skills/* .agents/skills/

# Copilot-Instruktionen
mkdir -p .github/instructions
touch .github/copilot-instructions.md
```

Details: [Section 14 — Plattformvergleich](#14-agent-skills-open-standard--plattformvergleich)

### Schritt 10: Verifizieren

```bash
# Context prüfen (was Claude beim Start sieht):
/context

# Auto Memory aktivieren (opt-in):
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0

# Test-Session starten:
claude
```

### Checkliste nach dem Setup

- [ ] CLAUDE.md ist ≤120 Zeilen und enthält nur nicht-offensichtliche Infos
- [ ] `.claude/rules/` hat mindestens eine pfad-spezifische Regel
- [ ] Skills installiert und mit `/context` sichtbar
- [ ] `.gitignore` enthält `CLAUDE.local.md` (wird automatisch hinzugefügt)
- [ ] Hooks in `.claude/settings.json` registriert (nicht nur das Script erstellt!)
- [ ] Hooks funktionieren (`git commit` löst pre-commit aus)
- [ ] Aktions-Commands haben `disable-model-invocation: true` im Frontmatter
- [ ] MCP-Server getestet (falls konfiguriert)

---

## 1. Memory-Hierarchie

Claude Code lädt Instruktionen aus mehreren Quellen in einer definierten Hierarchie. Spezifischere Instruktionen überschreiben allgemeinere:

| Ebene | Pfad | Scope | Inhalt | Wer profitiert |
| --- | --- | --- | --- | --- |
| **Managed Policy** | `C:\Program Files\ClaudeCode\CLAUDE.md` (Win) / `/Library/Application Support/ClaudeCode/CLAUDE.md` (Mac) | Organisations-weit | Company-Standards, Security-Policies | Alle in der Organisation |
| **User Memory** | `~/.claude/CLAUDE.md` | Alle Projekte eines Users | Persönliche Präferenzen, Shortcuts | Nur du (global) |
| **User Rules** | `~/.claude/rules/*.md` | Alle Projekte eines Users | Persönliche Coding-Regeln | Nur du (global) |
| **Project Memory** | `./CLAUDE.md` oder `./.claude/CLAUDE.md` | Projekt (Team-shared) | Architektur, Coding-Standards, Workflows | Team via Git |
| **Project Memory (local)** | `./CLAUDE.local.md` | Projekt (nur du) | Persönliche Sandbox-URLs, Test-Daten | Nur du (aktuelles Projekt) |
| **Project Rules** | `./.claude/rules/*.md` | Projekt (Team-shared) | Sprach-/Pfad-spezifische Guidelines | Team via Git |
| **Auto Memory** | `~/.claude/projects/<project>/memory/` | Projekt (nur du) | Claude's automatische Notizen | Nur du (per Projekt) |

### Lade-Verhalten

- CLAUDE.md-Dateien **oberhalb** des Working Directory werden **vollständig** beim Start geladen
- CLAUDE.md-Dateien in **Unterverzeichnissen** werden **on-demand** geladen, wenn Claude Dateien dort liest
- `.claude/rules/*.md` werden beim Start geladen (außer pfad-scoped Regeln — diese on-demand)
- Auto Memory: nur die **ersten 200 Zeilen** von `MEMORY.md` werden geladen

---

## 2. CLAUDE.md — Die Hauptdatei

### Goldene Regel

> *"Keep it concise. For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it. Bloated CLAUDE.md files cause Claude to ignore your actual instructions!"*

### Was hinein gehört

| Kategorie | Beispiel |
| --- | --- |
| Bash-Commands die Claude nicht erraten kann | `npm run test:sync-baseline` |
| Code-Style die von Defaults abweicht | "Use 2-space indentation", "IIFE pattern for configs" |
| Test-Anweisungen & bevorzugte Runner | "Run `npm test` for unit tests, `npm run test:webview` for E2E" |
| Repo-Etikette | "Commit format: `type(scope): description`" |
| Projekt-spezifische Architektur-Entscheidungen | "Config-driven: all data in config/*.js (IIFE + Object.freeze)" |
| Dev-Environment Besonderheiten | "Activate hooks: `git config core.hooksPath .githooks`" |
| Häufige Gotchas / nicht-offensichtliches Verhalten | "No leading `/` or `./` in paths — breaks iFrame context" |
| Compaction-Hinweis | "When compacting, always preserve: list of modified files, pending test results, current task state, active branch name" |

### Was NICHT hinein gehört

| Kategorie | Warum nicht | Alternative |
| --- | --- | --- |
| File-by-file Beschreibungen der Codebase | Claude kann Code lesen | `@`-Imports oder Skills |
| Standard-Sprachkonventionen die Claude kennt | Redundant — Claude weiß ES6, CSS, HTML | Weglassen |
| Detaillierte API-Dokumentation | Zu lang | Verlinken statt kopieren |
| Information die sich häufig ändert | Drift-Risiko | Dynamisch ableiten (Scripts) |
| Lange Erklärungen oder Tutorials | Füllt Context | In Skills auslagern |
| Selbstverständliches ("write clean code") | Kein Mehrwert | Weglassen |

### Formatierung

- **Bullet Points unter Markdown-Headings** — keine Prosa-Absätze
- **Spezifisch statt vage**: `"Use ES modules (import/export)"` > `"Use modern syntax"`
- **Emphasis für kritische Regeln**: `IMPORTANT`, `YOU MUST`, `NEVER` erhöht die Einhaltung
- **Kein festes Format vorgeschrieben** — aber kurz und menschenlesbar

### Empfohlene Länge

Anthropic nennt kein hartes Limit, warnt aber wiederholt vor zu langen Dateien. Aus der Praxis:

| Zeilen | Bewertung |
| --- | --- |
| 50–80 | Ideal für kleine/mittlere Projekte |
| 80–120 | Akzeptabel für komplexe Projekte |
| 120–150 | Grenzbereich — prüfen ob Auslagerung in Rules/Skills möglich |
| 150+ | Problematisch — Regeln werden ignoriert, Context wird verschwendet |

### Bootstrap

```bash
# Generiert eine Starter-CLAUDE.md basierend auf der Codebase:
/init
```

### Standort-Optionen

| Pfad | Wann verwenden |
| --- | --- |
| `./CLAUDE.md` (Root) | Standard — sichtbar, ins Git einchecken |
| `./.claude/CLAUDE.md` | Wenn Root-Verzeichnis sauber bleiben soll |
| Beide | Möglich — werden kombiniert geladen |

---

## 3. `.claude/rules/` — Modulare Regeln

### Wann statt CLAUDE.md

- Projekt hat **mehrere Domains** (Frontend, Backend, Config, Docs)
- Regeln gelten nur für **bestimmte Dateitypen/Pfade**
- CLAUDE.md wird zu lang (>120 Zeilen)

### Grundstruktur

```text
.claude/rules/
├── code-style.md         # Allgemeine Code-Konventionen
├── testing.md            # Test-Konventionen
├── security.md           # Sicherheitsanforderungen
├── frontend/
│   ├── css-touch.md      # Touch-spezifische CSS-Regeln
│   └── accessibility.md  # ARIA/Keyboard-Patterns
└── backend/
    └── api.md            # API-Design-Regeln
```

### Pfad-spezifische Regeln (Conditional Loading)

Regeln können mit `paths:` Frontmatter auf bestimmte Dateien beschränkt werden. Sie werden **nur geladen**, wenn Claude an passenden Dateien arbeitet:

```markdown
---
paths:
  - "newsletter-template.html"
  - "config/*.js"
---

# Touch-First CSS Rules

- `touch-action: manipulation` on every interactive element
- All `:hover` rules inside `@media (hover: hover) and (pointer: fine)`
- `-webkit-tap-highlight-color: transparent` on tappable elements
```

### Glob-Patterns

| Pattern | Matches |
| --- | --- |
| `**/*.ts` | Alle TypeScript-Dateien |
| `src/**/*` | Alles unter src/ |
| `*.md` | Markdown nur im Root |
| `src/components/*.tsx` | React-Komponenten in einem Ordner |

Brace Expansion wird unterstützt:

```yaml
paths:
  - "src/**/*.{ts,tsx}"        # .ts UND .tsx
  - "{src,lib}/**/*.ts"        # src/ ODER lib/
```

### Regeln ohne `paths:`

Werden **bedingungslos geladen**, wie Inhalt in CLAUDE.md. Selbe Priorität wie `.claude/CLAUDE.md`.

### Unterverzeichnisse

Regeln können in Subdirectories organisiert werden. Alle `.md`-Dateien werden **rekursiv** entdeckt:

```text
.claude/rules/
├── frontend/
│   ├── react.md
│   └── styles.md
├── backend/
│   ├── api.md
│   └── database.md
└── general.md
```

### Symlinks

```bash
# Shared Rules über Projekte hinweg:
ln -s ~/shared-claude-rules .claude/rules/shared

# Einzelne Rule-Dateien:
ln -s ~/company-standards/security.md .claude/rules/security.md
```

Symlinks werden aufgelöst und normal geladen. Zirkuläre Symlinks werden erkannt.

### User-Level Rules

Persönliche Regeln für **alle Projekte** in `~/.claude/rules/`:

```text
~/.claude/rules/
├── preferences.md    # Persönliche Coding-Präferenzen
└── workflows.md      # Bevorzugte Workflows
```

User-Level-Rules werden **vor** Projekt-Rules geladen (niedrigere Priorität).

---

## 4. `.claude/skills/` — On-Demand-Wissen

### Wofür

Skills erweitern Claude's Wissen mit **domänenspezifischen Informationen** oder **wiederholbaren Workflows**. Im Unterschied zu Rules/CLAUDE.md werden Skills **nicht immer geladen**, sondern nur wenn relevant.

> *"CLAUDE.md is loaded every session, so only include things that apply broadly. For domain knowledge or workflows that are only relevant sometimes, use skills instead. Claude loads them on demand without bloating every conversation."*

### Struktur

```text
.claude/skills/
├── api-conventions/
│   └── SKILL.md
├── fix-issue/
│   └── SKILL.md
└── deploy/
    └── SKILL.md
```

### Skill-Datei Format

```markdown
---
name: api-conventions
description: REST API design conventions for our services
---

# API Conventions

- Use kebab-case for URL paths
- Use camelCase for JSON properties
- Always include pagination for list endpoints
- Version APIs in the URL path (/v1/, /v2/)
```

### Workflow-Skills mit Invokation

Skills können als **aufrufbare Workflows** definiert werden:

```markdown
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR
```

Aufruf: `/fix-issue 1234`

- `$ARGUMENTS` wird durch die übergebenen Argumente ersetzt
- `disable-model-invocation: true` verhindert automatische Auslösung — nur manuell per `/skill-name`

### Empfohlene Basis-Skills

Die folgenden 8 universellen Skills bilden eine solide Grundlage für jedes Projekt. Installation via `npx skills add <repo> --skill <name> --copy -a claude-code -y`:

| Skill | Quelle | Beschreibung |
| --- | --- | --- |
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Hilft beim Entdecken und Installieren weiterer Skills aus dem Ökosystem |
| `frontend-design` | [anthropics/skills](https://github.com/anthropics/skills) | Production-grade Frontend-Interfaces mit hoher Designqualität |
| `skill-creator` | [anthropics/skills](https://github.com/anthropics/skills) | Anleitung zum Erstellen eigener Skills (Struktur, Frontmatter, Progressive Disclosure) |
| `brainstorming` | [obra/superpowers](https://github.com/obra/superpowers) | Socratic Design Refinement — klärt Anforderungen vor dem Coden |
| `writing-plans` | [obra/superpowers](https://github.com/obra/superpowers) | Zerlegt Arbeit in kleine, verifizierbare Implementierungsschritte |
| `systematic-debugging` | [obra/superpowers](https://github.com/obra/superpowers) | 4-Phasen Root-Cause-Analyse (Observe → Hypothesize → Test → Fix) |
| `requesting-code-review` | [obra/superpowers](https://github.com/obra/superpowers) | Pre-Review-Checkliste, prüft Code gegen Plan und Qualitätskriterien |
| `using-superpowers` | [obra/superpowers](https://github.com/obra/superpowers) | Einführung in das Superpowers-Skill-System |

**Installation aller 8 Skills:**

```bash
# Vercel + Anthropic Skills
npx skills add vercel-labs/skills --skill find-skills --copy -a claude-code -y
npx skills add anthropics/skills --skill frontend-design --skill skill-creator --copy -a claude-code -y

# Obra Superpowers Skills
npx skills add obra/superpowers --skill brainstorming --skill writing-plans --skill systematic-debugging --skill requesting-code-review --skill using-superpowers --copy -a claude-code -y
```

**Multi-Agent-Sync:** Um dieselben Skills auch für Copilot, Codex, Cursor etc. verfügbar zu machen:

```bash
mkdir -p .agents/skills
cp -r .claude/skills/* .agents/skills/
```

> **Hinweis:** Projektspezifische Skills (z.B. `add_newsletter_brand`) kommen zusätzlich dazu und werden nicht hier aufgelistet.

### Skills vs. Rules vs. CLAUDE.md

| Feature | CLAUDE.md | Rules | Skills |
| --- | --- | --- | --- |
| Laden | Immer (jede Session) | Immer oder pfad-bedingt | On-demand |
| Zweck | Globale Projekt-Regeln | Spezifische Coding-Standards | Domänen-Wissen, Workflows |
| Context-Verbrauch | Permanent | Permanent (oder bedingt) | Nur wenn benötigt |
| Aufruf | Automatisch | Automatisch | Automatisch oder `/skill-name` |
| Ideal für | Constraints, Commands | CSS-Regeln, Test-Konventionen | Brand hinzufügen, Deploy, Audit |

---

## 5. `.claude/commands/` — Slash Commands

### Wofür

Slash Commands sind **vordefinierte Prompts**, die Claude mit `/command-name` ausführt. Sie sind die Claude-Code-Variante von `.agent/workflows/`.

### Struktur

```text
.claude/commands/
├── add-brand.md
├── doc-audit.md
├── feature-delivery.md
└── hotfix.md
```

### Frontmatter

```markdown
---
description: Full checklist for adding a new brand
allowed-tools: Read, Grep, Glob, Edit, MultiEdit, Write, Bash
---

# Add Brand

Follow `.agent/workflows/add-brand.md` strictly.
...
```

- `description` — Kurzbeschreibung (wird in der Command-Liste angezeigt)
- `allowed-tools` — Einschränkung der verfügbaren Tools für diesen Command

#### `disable-model-invocation: true` — Pflicht für Aktions-Workflows

Für Workflows mit Seiteneffekten (Deploy, Hotfix, Release, Commit) **muss** dieses Flag gesetzt sein, sonst kann Claude den Workflow automatisch auslösen wenn es kontextuell passend erscheint:

```markdown
---
description: Execute hotfix deployment to production
disable-model-invocation: true
---

# Hotfix
...
```

| Workflow-Typ | `disable-model-invocation` |
| --- | --- |
| Deploy, Hotfix, Release | **Immer `true`** |
| Commit, Push | **Immer `true`** |
| Audit, Analyse (read-only) | Optional (empfohlen) |
| Feature-Delivery (Implementierung) | Empfohlen |

### Commands vs. Skills

| Feature | Commands | Skills |
| --- | --- | --- |
| Aufruf | `/command-name` | `/skill-name` oder automatisch |
| Zweck | Vordefinierte Prompts/Workflows | Wissen + Workflows |
| Argumente | Fester Prompt | `$ARGUMENTS` Support |
| Automatische Erkennung | Nein (nur manuell) | Ja (Claude erkennt Relevanz) |

---

## 6. `.claude/agents/` — Custom Subagents

### Wofür

Subagents sind **spezialisierte Assistenten**, die in **eigenem Context** mit **eigenen Tool-Beschränkungen** laufen. Sie sind ideal für Tasks die viele Dateien lesen oder spezialisierten Fokus brauchen, ohne den Hauptcontext zu belasten.

> *"Subagents run in their own context with their own set of allowed tools. They're useful for tasks that read many files or need specialized focus without cluttering your main conversation."*

### Struktur

```text
.claude/agents/
├── security-reviewer.md
├── doc-auditor.md
└── performance-analyzer.md
```

### Agent-Datei Format

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob, Bash
model: opus
---

You are a senior security engineer. Review code for:
- Injection vulnerabilities (SQL, XSS, command injection)
- Authentication and authorization flaws
- Secrets or credentials in code
- Insecure data handling

Provide specific line references and suggested fixes.
```

### Projektspezifisches Beispiel: qa-reviewer

Kleiner, read-only Spezialist der nach Feature-Edits proaktiv angewendet werden kann:

```markdown
---
name: qa-reviewer
description: Use proactively after editing newsletter-template.html or config files. Reviews for XSS vulnerabilities, CSS touch compliance, avatar rendering, and API contract violations.
tools: Read, Grep, Glob
model: haiku
---

You are a QA engineer for a mobile WebView newsletter template. Review for:

**Critical**
- All config-derived innerHTML uses `escapeHtml()` (XSS)
- All brand avatars use `buildAvatarImgHTML()` (no manual `<img>` tags)
- Variant IDs unchanged: `inbox-ad-image-clickout-17-5`, `inbox-ad-clickout`, `inbox-ad-image-branding-1-91`

**High**
- All `:hover` rules inside `@media (hover: hover) and (pointer: fine)`
- All interactive elements have `touch-action: manipulation`
- No hardcoded brand/category counts

**Medium**
- Relative paths only (no leading `/` or `./`)
- No `localStorage`, `sessionStorage`, `postMessage`
- No runtime framework imports

Output: severity-classified list (Critical/High/Medium/Low) with file:line references.
```

Dieses Pattern ist optimal für projektspezifische Regeln die bei jedem Edit geprüft werden sollen, ohne den Haupt-Context zu belasten.

### Konfigurationsfelder

| Feld | Beschreibung |
| --- | --- |
| `name` | Identifier |
| `description` | Was der Agent tut |
| `tools` | Erlaubte Tools (z.B. `Read, Grep, Glob, Bash`) |
| `model` | Welches Modell (z.B. `opus`, `sonnet`) |

### Aufruf

```text
Use a subagent to review this code for security issues.
```

Oder explizit:

```text
Use the doc-auditor subagent to check documentation drift.
```

### Wann Subagents statt Commands

| Subagents | Commands |
| --- | --- |
| Task liest viele Dateien (Context-Schonung) | Task hat klaren linearen Ablauf |
| Spezialisierter Fokus nötig | Genereller Workflow |
| Ergebnis = Bericht (read-only) | Ergebnis = Code-Änderungen |
| Parallelisierbar (Writer/Reviewer Pattern) | Sequentiell |

### Writer/Reviewer Pattern

Ein mächtiges Pattern mit zwei Agents:

| Session A (Writer) | Session B (Reviewer) |
| --- | --- |
| Implementiere Feature X | — |
| — | Reviewe die Implementierung in `@src/feature.ts`. Finde Edge Cases, Race Conditions. |
| Hier das Feedback: [Session B Output]. Behebe die Issues. | — |

---

## 7. `.claude/hooks/` — Deterministische Hooks

### Wofür

Hooks sind **Scripts die automatisch** an bestimmten Punkten in Claude's Workflow laufen. Im Unterschied zu CLAUDE.md-Instruktionen (die "advisory" sind) sind Hooks **deterministisch und garantiert**.

> *"Unlike CLAUDE.md instructions which are advisory, hooks are deterministic and guarantee the action happens."*

### Hook-Typen

Hooks können an verschiedenen Stellen im Workflow eingehängt werden. Typische Trigger:

- **Nach jedem File-Edit** — z.B. ESLint ausführen
- **Vor File-Writes** — z.B. bestimmte Dateien schützen
- **Nach Tool-Aufrufen** — z.B. Logging

### Beispiel: File Protection Hook

```bash
#!/bin/bash
# protect-files.sh — Blocks modifications to critical files

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(".env" "package-lock.json" ".git/" "CLAUDE.md" "AGENTS.md")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'." >&2
    exit 2  # Exit 2 = block the action
  fi
done

exit 0  # Exit 0 = allow
```

### KRITISCH: Hooks müssen in `settings.json` registriert werden

Ein Hook-Script das nur in `.claude/hooks/` liegt ist **Dead Code** — es wird niemals ausgeführt. Die Registrierung in `.claude/settings.json` ist **zwingend erforderlich**:

```json
// .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }]
      }
    ]
  }
}
```

Ohne diesen Eintrag: Hook-Script existiert, wird nie aufgerufen, kein Fehler, kein Hinweis — stille Fehlfunktion.

### Hooks erstellen lassen

Claude kann Hooks selbst schreiben:

```text
Write a hook that runs eslint after every file edit
Write a hook that blocks writes to the migrations folder
```

Interaktive Konfiguration: `/hooks`

Oder direkt in `.claude/settings.json` bearbeiten.

### Hooks vs. CLAUDE.md-Regeln

| Hooks | CLAUDE.md-Regeln |
| --- | --- |
| **Deterministisch** — laufen immer | **Advisory** — Claude kann ignorieren |
| Für Actions die 100% passieren müssen | Für Guidance die Entscheidung beeinflusst |
| Shell-Scripts | Markdown-Text |
| Exit 2 = Block, Exit 0 = Allow | Keine Enforcement-Mechanik |

---

## 8. Auto Memory

### Was es ist

Auto Memory ist ein **persistentes Verzeichnis** in dem Claude automatisch Learnings, Patterns und Insights während der Arbeit speichert. Im Unterschied zu CLAUDE.md (du schreibst für Claude) enthält Auto Memory **Notizen die Claude für sich selbst schreibt**.

### Was Claude speichert

- **Projekt-Patterns:** Build-Commands, Test-Konventionen, Code-Style
- **Debugging-Insights:** Lösungen für knifflige Probleme, häufige Fehlerursachen
- **Architektur-Notizen:** Key Files, Modul-Beziehungen, wichtige Abstraktionen
- **Deine Präferenzen:** Kommunikationsstil, Workflow-Gewohnheiten, Tool-Vorlieben

### Speicherort

```text
~/.claude/projects/<project>/memory/
├── MEMORY.md          # Index — erste 200 Zeilen werden geladen
├── debugging.md       # Detail-Notizen zu Debugging
├── api-conventions.md # API-Design-Entscheidungen
└── ...                # Beliebige weitere Topic-Dateien
```

### Lade-Verhalten

- **MEMORY.md:** Erste 200 Zeilen werden beim Session-Start in den System-Prompt geladen
- **Topic-Dateien** (debugging.md etc.): Werden **nicht** beim Start geladen — Claude liest sie on-demand
- Claude hält `MEMORY.md` **knapp** und lagert Details in Topic-Dateien aus

### Steuerung

```bash
# Aktivieren (opt-in während Rollout):
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0

# Deaktivieren:
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
```

Claude etwas explizit merken lassen:

```text
Remember that we use pnpm, not npm.
Save to memory that the API tests require a local Redis instance.
```

Bearbeiten: `/memory` öffnet die Dateien im System-Editor.

---

## 9. `@`-Import-Syntax

### Was es ist

CLAUDE.md-Dateien können andere Dateien importieren mit `@path/to/file`:

```markdown
See @README.md for project overview and @package.json for available npm commands.

# Additional Instructions
- Git workflow: @docs/git-instructions.md
- Personal overrides: @~/.claude/my-project-instructions.md
```

### Verhalten

- **Relative Pfade** werden relativ zur Datei aufgelöst die den Import enthält (nicht zum Working Directory)
- **Absolute Pfade** und **Home-Directory** (`~`) werden unterstützt
- Imports sind **rekursiv** (max 5 Hops tief)
- Imports in Markdown-Code-Spans (`` `@foo` ``) und Code-Blocks werden **nicht** aufgelöst
- Beim ersten Encounter zeigt Claude ein **Approval-Dialogfeld** — einmalige Entscheidung pro Projekt

### Wofür

| Statt | Verwende |
| --- | --- |
| npm Scripts in CLAUDE.md auflisten | `@package.json` |
| Architektur-Doku in CLAUDE.md kopieren | `@docs/ARCHITECTURE.md` |
| Persönliche Regeln pro Projekt | `@~/.claude/my-project-instructions.md` |

### Worktree-Support

```markdown
# Funktioniert über Git Worktrees hinweg:
@~/.claude/my-project-instructions.md
```

Statt `CLAUDE.local.md` (existiert nur in einem Worktree) kann ein Home-Directory-Import alle Worktrees abdecken.

---

## 10. CLAUDE.local.md — Persönliche Overrides

### Was es ist

`CLAUDE.local.md` ist eine **persönliche, projektspezifische** Datei die automatisch geladen wird aber **nicht ins Git** eingecheckt wird (automatisch zu `.gitignore` hinzugefügt).

### Wofür

| Beispiel | Warum lokal |
| --- | --- |
| Sandbox/Dev-URLs | Unterscheiden sich pro Entwickler |
| Bevorzugte Test-Daten | Persönliche Präferenz |
| Extra-Debugging-Befehle | Nicht für alle relevant |
| Feature-Flag-Overrides | Temporär, entwickler-spezifisch |

### Beispiel

```markdown
# My local dev setup
- Dev server: http://localhost:3001
- Use `npm run test:webview:headed` for visual debugging
- My test user: testuser@gmx.de / password123
```

---

## 11. Anti-Patterns & häufige Fehler

Direkt aus den offiziellen Anthropic Best Practices:

### The Over-Specified CLAUDE.md

> *"If your CLAUDE.md is too long, Claude ignores half of it because important rules get lost in the noise."*

**Fix:** Ruthlessly prune. Wenn Claude etwas bereits korrekt macht ohne die Instruktion → löschen. Oder in Hook konvertieren.

### The Kitchen Sink Session

Ein Task starten, etwas Unrelated fragen, zum ersten Task zurückkehren. Context ist voll mit irrelevantem Inhalt.

**Fix:** `/clear` zwischen unrelated Tasks.

### Correcting Over and Over

Claude macht etwas falsch → korrigieren → immer noch falsch → nochmal korrigieren. Context ist polluted mit fehlgeschlagenen Ansätzen.

**Fix:** Nach 2 fehlgeschlagenen Korrekturen: `/clear` und besseren initialen Prompt schreiben.

### The Trust-Then-Verify Gap

Claude produziert plausibel aussehende Implementierung die Edge Cases nicht behandelt.

**Fix:** Immer Verifikation mitgeben (Tests, Scripts, Screenshots).

### The Infinite Exploration

"Investigate X" ohne Scoping → Claude liest hunderte Dateien, Context ist voll.

**Fix:** Untersuchungen eng scopen oder **Subagents** nutzen.

### CLAUDE.md-spezifische Warnsignale

| Signal | Problem | Lösung |
| --- | --- | --- |
| Claude ignoriert eine Regel trotz CLAUDE.md-Eintrag | Datei zu lang, Regel geht unter | Datei kürzen, Emphasis (`IMPORTANT`) hinzufügen |
| Claude fragt nach etwas das in CLAUDE.md steht | Formulierung ist mehrdeutig | Klarer/spezifischer formulieren |
| Info ändert sich häufig | Drift-Risiko, veraltete Info | Dynamisch ableiten oder `@`-Import nutzen |

### Hook-Script ohne `settings.json` — Dead Code

> *"The hook script exists, is never called, no error, no warning. Silent failure."*

Einer der häufigsten Einrichtungsfehler: Ein `.claude/hooks/protect-files.sh` wird erstellt, aber kein Eintrag in `.claude/settings.json` wird angelegt.

**Symptom:** Geschützte Dateien können trotzdem editiert werden. Kein Fehler, kein Hinweis.

**Fix:** Immer nach dem Erstellen eines Hook-Scripts die Registrierung in `.claude/settings.json` prüfen:

```json
// .claude/settings.json (erforderlich!)
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }]
      }
    ]
  }
}
```

**Prüfung:** `/hooks` in einer Claude-Session zeigt alle aktiven Hooks. Wenn der Hook dort nicht erscheint, ist er nicht registriert.

---

## 12. Optimale Verzeichnisstruktur (exemplarisch)

Basierend auf allen Anthropic-Features — so sieht ein vollständig ausgestattetes Claude-Code-Setup aus:

```text
project-root/
├── CLAUDE.md                          # Hauptdatei: kurz & knackig (80–120 Zeilen)
│                                      # → Projekt-Kontext, kritische Constraints,
│                                      #   Commands, Do-NOTs, Testing-Workflow
│                                      # → @package.json für npm Scripts
│
├── CLAUDE.local.md                    # Persönlich (auto-gitignored)
│                                      # → Dev-URLs, Test-Credentials, Overrides
│
├── .claude/
│   ├── CLAUDE.md                      # Optional: Alternative zu Root-CLAUDE.md
│   │
│   ├── rules/                         # Modulare, pfad-spezifische Regeln
│   │   ├── general.md                 # Immer geladen (kein paths: Frontmatter)
│   │   ├── css-touch.md               # paths: ["**/*.html", "**/*.css"]
│   │   ├── avatar-system.md           # paths: ["config/newsletter-brands-config.js",
│   │   │                              #          "newsletter-template.html"]
│   │   ├── config-patterns.md         # paths: ["config/*.js"]
│   │   ├── accessibility.md           # paths: ["newsletter-template.html"]
│   │   ├── markdown-quality.md        # paths: ["**/*.md"]
│   │   └── frontend/                  # Subdirectories für Gruppierung
│   │       └── animations.md
│   │
│   ├── skills/                        # On-demand Domänen-Wissen & Workflows
│   │   ├── add-brand/
│   │   │   └── SKILL.md               # name: add-brand
│   │   │                              # description: Add a new newsletter brand
│   │   │                              # → Vollständige Checklist, Category-Tabelle
│   │   ├── fix-issue/
│   │   │   └── SKILL.md               # name: fix-issue
│   │   │                              # disable-model-invocation: true
│   │   │                              # → Aufruf: /fix-issue 1234
│   │   └── brainstorming/
│   │       └── SKILL.md
│   │
│   ├── commands/                      # Slash Commands (vordefinierte Prompts)
│   │   ├── doc-audit.md               # /doc-audit → Audit-Workflow
│   │   ├── feature-delivery.md        # /feature-delivery → Feature-Workflow
│   │   ├── hotfix.md                  # /hotfix → Hotfix-Workflow
│   │   └── release-readiness.md       # /release-readiness → Release-Gate
│   │
│   ├── agents/                        # Custom Subagents (eigener Context)
│   │   ├── doc-auditor.md             # Spezialist für Documentation-Drift
│   │   │                              # tools: Read, Grep, Glob, Bash
│   │   ├── security-reviewer.md       # Spezialist für Security-Review
│   │   │                              # tools: Read, Grep, Glob
│   │   │                              # model: opus
│   │   └── test-writer.md             # Spezialist für Test-Generierung
│   │       
│   ├── hooks/                         # Deterministische Hooks
│   │   └── protect-files.sh           # Schützt kritische Dateien vor Modifikation
│   │
│   └── settings.json                  # Claude Code Settings (Permissions etc.)
│
└── .githooks/                         # Git Hooks (unabhängig von Claude)
    ├── pre-commit
    └── commit-msg
```

### Inhaltliche Aufteilung

```text
┌──────────────────────────────────────────────────────────────────┐
│ CLAUDE.md (~100 Zeilen)                                         │
│  • Projekt-Kontext (3 Zeilen)                                   │
│  • Critical Constraints (nur was Claude nicht erraten kann)      │
│  • @package.json (Import statt npm-Script-Liste)                │
│  • Commit-Format & Hook-Aktivierung                             │
│  • Do-NOT-Liste (die wichtigsten Verbote)                       │
│  • Testing-Workflow (Befehle, Reihenfolge)                      │
│  • Slash Commands Übersicht                                     │
└──────────────────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│ .claude/rules/ (pfad-spezifisch, immer oder bedingt geladen)    │
│  • CSS/Touch-Regeln → nur bei HTML/CSS-Arbeit                   │
│  • Avatar-System → nur bei Brand-Config/Template-Arbeit         │
│  • Config-Patterns → nur bei config/*.js-Arbeit                 │
│  • Accessibility → nur bei Template-Arbeit                      │
│  • Markdown Quality → nur bei *.md-Arbeit                       │
└──────────────────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│ .claude/skills/ (on-demand, Claude erkennt Relevanz)            │
│  • add-brand: 10-Schritte-Workflow für neue Brands              │
│  • fix-issue: GitHub Issue → PR Workflow                        │
│  • Domain-Wissen das nur manchmal relevant ist                  │
└──────────────────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│ .claude/agents/ (eigener Context, eigene Tools)                 │
│  • doc-auditor: Liest alle Docs, stört Haupt-Context nicht      │
│  • security-reviewer: Code-Review in isoliertem Context         │
└──────────────────────────────────────────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────────────────────────────────┐
│ .claude/hooks/ (deterministisch, 100% Enforcement)              │
│  • protect-files.sh: Blockiert Writes auf kritische Dateien     │
│  • Auto-Lint nach File-Edits                                    │
└──────────────────────────────────────────────────────────────────┘
```

---

## 13. Checkliste: CLAUDE.md Audit

Verwende diese Checkliste um dein CLAUDE.md Setup zu bewerten:

### Länge & Fokus

- [ ] CLAUDE.md ist ≤120 Zeilen
- [ ] Jede Zeile besteht den Test: "Würde Claude ohne diese Zeile Fehler machen?"
- [ ] Keine Standard-Konventionen die Claude bereits kennt
- [ ] Keine file-by-file Codebase-Beschreibungen
- [ ] Keine langen Tutorials oder Erklärungen
- [ ] Keine Information die sich häufig ändert (dynamisch ableiten stattdessen)

### Struktur & Format

- [ ] Bullet Points unter Markdown-Headings (keine Prosa)
- [ ] Spezifische Anweisungen statt vage Guidance
- [ ] Kritische Regeln mit Emphasis markiert (`IMPORTANT`, `NEVER`)
- [ ] `@`-Imports wo sinnvoll (package.json, README)

### Modulare Auslagerung

- [ ] Pfad-spezifische Regeln in `.claude/rules/` mit `paths:` Frontmatter
- [ ] Domänen-Wissen und Workflows in `.claude/skills/`
- [ ] Read-heavy Tasks als `.claude/agents/` Subagents
- [ ] Garantierte Actions als `.claude/hooks/`

### Hooks & Settings

- [ ] `.claude/settings.json` existiert und registriert alle Hooks
- [ ] Hook-Scripts sind executable (`chmod +x`)
- [ ] Aktions-Commands (Deploy, Hotfix, Release) haben `disable-model-invocation: true`

### Team & Hygiene

- [ ] CLAUDE.md ins Git eingecheckt
- [ ] Persönliche Overrides in CLAUDE.local.md (auto-gitignored)
- [ ] Kein Drift zwischen CLAUDE.md und tatsächlichem Code (regelmäßig prüfen)
- [ ] `/memory` zum Bearbeiten von Auto Memory nutzen

---

## 14. Agent Skills Open Standard — Plattformvergleich

### Hintergrund

Claude Code und Google Antigravity (die Gemini-CLI / Agentic IDE) folgen beide dem [Agent Skills Open Standard](https://agentskills.io/) — einem offenen Format für wiederverwendbare Skill-Pakete, das plattformübergreifend funktioniert. Das Kernformat ist identisch: ein `SKILL.md` Entrypoint mit YAML-Frontmatter in einem benannten Ordner. Die Plattformen unterscheiden sich jedoch erheblich in der Tiefe der unterstützten Features.

Quellen:

- [Claude Code — Skills](https://code.claude.com/docs/en/skills)
- [Antigravity — Skills](https://antigravity.google/docs/skills)
- [Agent Skills Standard](https://agentskills.io/)

### Gemeinsames Grundformat

Beide Plattformen verwenden exakt dasselbe Basis-Layout:

```text
<skills-root>/<skill-name>/
└── SKILL.md           # Entrypoint (required)
    ├── YAML Frontmatter (name + description)
    └── Markdown Body (Instruktionen)
```

Minimales Beispiel (funktioniert auf **beiden** Plattformen):

```markdown
---
name: code-review
description: Reviews code changes for bugs, style issues, and best practices.
---

# Code Review

When reviewing code, check:
1. Correctness — Does the code do what it's supposed to?
2. Edge cases — Are error conditions handled?
3. Style — Does it follow project conventions?
```

### Speicherorte

| Scope | Claude Code | Antigravity (Gemini) | Kilo Code |
| --- | --- | --- | --- |
| **Projekt** | `.claude/skills/<name>/` | `.agent/skills/<name>/` | `.kilocode/skills/<name>/` |
| **Universal** | `.agents/skills/<name>/` | `.agents/skills/<name>/` | `.agents/skills/<name>/` |
| **Global (User)** | `~/.claude/skills/<name>/` | `~/.gemini/antigravity/skills/<name>/` | `~/.kilocode/skills/<name>/` |
| **Enterprise/Managed** | Via Managed Settings (zentral) | — (nicht dokumentiert) | — (nicht dokumentiert) |
| **Plugin** | `<plugin>/skills/<name>/` | — | — |

**Priorität bei Namenskollision (Claude Code):** Enterprise > Personal > Project. Plugin-Skills verwenden Namespace (`plugin-name:skill-name`).

**Antigravity:** Workspace-Skills überschreiben Global-Skills bei gleichem Namen (implizit).

### Discovery & Loading

Beide Plattformen nutzen **Progressive Disclosure** — ein dreistufiges Lademodell:

| Stufe | Was wird geladen | Wann |
| --- | --- | --- |
| **1. Metadata** | `name` + `description` aus Frontmatter | Immer (Session-Start) |
| **2. SKILL.md Body** | Vollständiger Markdown-Inhalt | Wenn Agent den Skill als relevant erkennt |
| **3. Supporting Files** | Scripts, References, Assets | On-demand durch Agent |

**Claude Code** hat ein explizites **Context-Budget** für Skill-Descriptions: 2% des Context-Windows (dynamisch), Fallback 16.000 Zeichen. Bei zu vielen Skills werden einige ausgeschlossen. Prüfbar via `/context`.

**Antigravity** dokumentiert kein explizites Budget — der Agent sieht die Skill-Liste und entscheidet autonom.

### Frontmatter-Felder im Vergleich

#### Gemeinsame Felder

| Feld | Required? | Beschreibung |
| --- | --- | --- |
| `name` | Nein (empfohlen) | Eindeutiger Identifier. Lowercase, Hyphens, max 64 Zeichen. Default = Ordnername. |
| `description` | Empfohlen | Was der Skill tut und **wann** er verwendet werden soll. Primärer Trigger-Mechanismus. |

Bei **beiden** Plattformen gilt: Die `description` ist das wichtigste Feld, da der Agent anhand dieser Beschreibung entscheidet, ob der Skill relevant ist. Best Practice: Keywords einbauen, die Nutzer natürlich verwenden würden.

#### Claude Code — Exklusive Frontmatter-Felder

Antigravity unterstützt **nur** `name` und `description`. Claude Code erweitert das Format erheblich:

| Feld | Typ | Beschreibung |
| --- | --- | --- |
| `disable-model-invocation` | `boolean` | `true` = Agent kann den Skill **nicht** automatisch laden. Nur manuell per `/skill-name`. Ideal für Workflows mit Seiteneffekten (Deploy, Commit). |
| `user-invocable` | `boolean` | `false` = Skill erscheint **nicht** im `/`-Menü. Für Hintergrundwissen das der Agent nutzt, nicht der User. |
| `allowed-tools` | `string` | Tool-Whitelist für aktiven Skill. Z.B. `Read, Grep, Glob` für Read-only-Modus. |
| `context` | `string` | `fork` = Skill läuft in isoliertem **Subagent-Context** (eigener Context, keine Conversation History). |
| `agent` | `string` | Subagent-Typ wenn `context: fork`. Built-in: `Explore`, `Plan`, `general-purpose`. Oder custom aus `.claude/agents/`. |
| `model` | `string` | Modell-Override für diesen Skill (z.B. `opus`, `sonnet`). |
| `hooks` | `object` | Skill-spezifische Hooks (deterministisch, Shell-basiert). |
| `argument-hint` | `string` | Autocomplete-Hint, z.B. `[issue-number]` oder `[filename] [format]`. |
| `license` | `string` | Lizenz-Info (z.B. `Complete terms in LICENSE.txt`). |

**Invocation-Matrix (Claude Code):**

| Konfiguration | User kann aufrufen? | Agent kann automatisch laden? |
| --- | --- | --- |
| Default (keine Felder) | Ja (`/name`) | Ja |
| `disable-model-invocation: true` | Ja (`/name`) | Nein |
| `user-invocable: false` | Nein | Ja |

### String-Substitution & Argumente

#### Substitution in Claude Code

Skills unterstützen Platzhalter die beim Aufruf ersetzt werden:

| Platzhalter | Beschreibung |
| --- | --- |
| `$ARGUMENTS` | Alle übergebenen Argumente als String |
| `$ARGUMENTS[N]` / `$N` | N-tes Argument (0-basiert) |
| `${CLAUDE_SESSION_ID}` | Aktuelle Session-ID |

Beispiel:

```markdown
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

Aufruf: `/fix-issue 123` → Agent erhält "Fix GitHub issue 123 following our coding standards."

Mehrere Argumente: `/migrate-component SearchBar React Vue` → `$0` = SearchBar, `$1` = React, `$2` = Vue.

#### Substitution in Antigravity

String-Substitution ist **nicht dokumentiert**. Skills in Antigravity funktionieren primär als passives Wissen, nicht als parametrisierte Workflows.

### Dynamische Kontext-Injektion

#### Claude Code — `!`command`` Syntax

Shell-Commands werden **vor** dem Laden ausgeführt, das Ergebnis wird in den Skill-Content eingefügt:

```markdown
---
name: pr-summary
description: Summarize changes in a pull request
context: fork
agent: Explore
allowed-tools: Bash(gh *)
---

## Pull request context
- PR diff: !`gh pr diff`
- PR comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

## Your task
Summarize this pull request.
```

Dies ist **Preprocessing** — der Agent sieht nur das finale Ergebnis mit den tatsächlichen Daten.

#### Kontext-Injektion in Antigravity

Dynamische Kontext-Injektion ist **nicht dokumentiert**. Kein Äquivalent zur `!`command`` Syntax.

### Subagent-Integration

#### Subagents in Claude Code

Mit `context: fork` läuft ein Skill in einem isolierten Subagent:

```markdown
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files using Glob and Grep
2. Read and analyze the code
3. Summarize findings with specific file references
```

- Der Subagent hat **keinen Zugriff** auf die Conversation History
- Ergebnisse werden zusammengefasst und in den Haupt-Context zurückgegeben
- `agent`-Feld bestimmt Toolset und Modell
- Inverse Richtung: Subagents können Skills als Referenzmaterial vorladen

#### Subagents in Antigravity

Antigravity hat kein Konzept für Skill-basierte Subagent-Delegation. Skills sind immer inline im Haupt-Context.

### Supporting Files

Beide Plattformen unterstützen zusätzliche Dateien im Skill-Ordner, verwenden aber leicht unterschiedliche Konventionen:

| Datei-Typ | Claude Code | Antigravity |
| --- | --- | --- |
| **Scripts** | `scripts/` — Executable Code | `scripts/` — Helper Scripts |
| **Referenzen** | `references/` — Doku als On-demand-Context | `resources/` — Templates und Assets |
| **Assets** | `assets/` — Output-Dateien (Logos, Templates) | — (in `resources/` zusammengefasst) |
| **Beispiele** | `examples/` | `examples/` |

**Claude Code Best Practice:**

- `SKILL.md` unter 500 Zeilen halten
- Detaillierte Referenzen in separate Dateien auslagern
- Von SKILL.md aus referenzieren: `For API details, see [reference.md](reference.md)`
- Referenzen maximal eine Ebene tief (kein verschachteltes Linking)
- Bei Dateien >100 Zeilen: Inhaltsverzeichnis am Anfang einfügen

**Antigravity Best Practice:**

- Scripts als Black Boxes behandeln — Agent soll `--help` aufrufen statt Source lesen
- Decision Trees für komplexe Skills einbauen
- Jeder Skill sollte genau eine Sache gut machen (Single Responsibility)

### Tool-Beschränkungen

#### Tool-Control in Claude Code

Skills können Tools einschränken oder freigeben:

```markdown
---
name: safe-reader
description: Read files without making changes
allowed-tools: Read, Grep, Glob
---
```

Permissions können auch auf Skill-Ebene gesteuert werden:

```text
# In /permissions:
Skill(deploy *)      # Deny deploy skill
Skill(commit)         # Allow only exact match
```

#### Tool-Control in Antigravity

Tool-Beschränkungen für Skills sind **nicht dokumentiert**. Skills haben Zugang zu allen Tools des Agents.

### Feature-Vergleich Gesamtübersicht

| Feature | Claude Code | Antigravity |
| --- | --- | --- |
| SKILL.md + Frontmatter | ✅ | ✅ |
| `name` + `description` | ✅ | ✅ |
| Progressive Disclosure | ✅ | ✅ |
| Supporting Files | ✅ (scripts, references, assets, examples) | ✅ (scripts, examples, resources) |
| Automatische Skill-Erkennung | ✅ | ✅ |
| Manueller Aufruf (`/name`) | ✅ | ❌ (nicht dokumentiert) |
| `disable-model-invocation` | ✅ | ❌ |
| `user-invocable` | ✅ | ❌ |
| `allowed-tools` | ✅ | ❌ |
| `context: fork` (Subagent) | ✅ | ❌ |
| `model` Override | ✅ | ❌ |
| `hooks` (Skill-scoped) | ✅ | ❌ |
| `$ARGUMENTS` Substitution | ✅ | ❌ |
| `!`command`` Injektion | ✅ | ❌ |
| Monorepo-Discovery (nested) | ✅ | ❌ (nicht dokumentiert) |
| Plugin-Skills | ✅ | ❌ |
| Enterprise/Managed Skills | ✅ | ❌ |
| Context-Budget (explizit) | ✅ (2% Window) | ❌ (nicht dokumentiert) |
| Live-Change-Detection | ✅ (via `--add-dir`) | ❌ |
| Skills-CLI (`npx skills`) | ✅ (kompatibel) | ✅ (kompatibel) |

### Cross-Agent Kompatibilität

Da mehrere Plattformen den gleichen Open Standard nutzen, können Skills plattformübergreifend geteilt werden — mit Einschränkungen.

#### Verzeichnis-Konventionen aller Tools

| Tool | Instructions-Datei | Skills-Verzeichnis (Workspace) | Skills-Verzeichnis (Global) |
| --- | --- | --- | --- |
| **Claude Code** | `CLAUDE.md` | `.claude/skills/<name>/` | `~/.claude/skills/<name>/` |
| **Google Antigravity** | `GEMINI.md` | `.agent/skills/<name>/` | `~/.gemini/antigravity/skills/<name>/` |
| **Gemini CLI** | `GEMINI.md` | `.gemini/skills/<name>/` oder `.agents/skills/<name>/` (Alias, hat Vorrang) | `~/.gemini/skills/<name>/` oder `~/.agents/skills/<name>/` |
| **OpenAI Codex** | `AGENTS.md` | `.agents/skills/<name>/` | `~/.agents/skills/<name>/` |
| **GitHub Copilot** | `.github/copilot-instructions.md` + `AGENTS.md` | `.github/instructions/*.instructions.md` | — |
| **Cursor** | `.cursor/rules/*.mdc` | `.agents/skills/<name>/` | — |

#### Zusätzliche Konventionen (nur Antigravity)

Antigravity unterstützt neben Skills auch diese `.agent/`-Unterverzeichnisse:

| Verzeichnis | Zweck |
| --- | --- |
| `.agent/rules/` | Always-on Regeln (äquivalent zu `.claude/rules/`) |
| `.agent/workflows/` | Wiederverwendbare Task-Prozeduren |
| `.agent/scripts/` | Helper-Scripts |

Diese existieren nur in Antigravity — kein anderes Tool erkennt sie automatisch.

#### Jules — nativ gelesene Dateien

**Google Jules** (der asynchrone Cloud-Agent unter [jules.google.com](https://jules.google.com)) ist von Antigravity getrennt und liest eigene Dateien:

| Datei | Wie Jules sie nutzt |
| --- | --- |
| `AGENTS.md` | **Primärer Kontext** — Jules liest diese Datei automatisch bei jeder Task-Ausführung (offiziell dokumentiert). Beschreibe hier Architektur, Constraints und Conventions. |
| `README.md` | **Fallback für Environment-Setup** — Jules greift auf `README.md` zurück, wenn kein Setup-Script konfiguriert ist, um Dependencies und Toolchain zu verstehen. |

> **Key Insight:** Jules kennt kein `CLAUDE.md`, kein `.agent/`, keine `.jules`-Config. Der einzige native Hebel ist `AGENTS.md`. Ein gut befülltes `AGENTS.md` ist deshalb die effektivste Maßnahme für bessere Jules-Ergebnisse. Quelle: [jules.google/docs](https://jules.google/docs)

#### Verzeichnis-Mapping in diesem Repo

| Verzeichnis | Für welche Tools | Inhalt |
| --- | --- | --- |
| `.agents/skills/` | Gemini CLI, OpenAI Codex, Cursor, VS Code Copilot | Agent Skills (Open Standard) |
| `.agent/skills/` | Google Antigravity | Agent Skills (gleiche Skills, Antigravity-Pfad) |
| `.agent/rules/` | Google Antigravity | Always-on Coding-Standards |
| `.agent/workflows/` | Google Antigravity | Task-Prozeduren (add-brand, doc-audit, etc.) |
| `.claude/rules/` | Claude Code | Pfad-spezifische Regeln |
| `.claude/commands/` | Claude Code | Slash Commands |
| `.github/copilot-instructions.md` | GitHub Copilot | Repo-weite Instruktionen |
| `.github/instructions/` | GitHub Copilot | Pfad-spezifische Instruktionen |

**Portabel (funktioniert überall):**

- Skills die nur `name` + `description` im Frontmatter nutzen
- Reiner Markdown-Body mit Instruktionen
- Supporting Files mit Standard-Unterordnern (`scripts/`, `examples/`)

**Nicht portabel (Claude Code → Antigravity):**

- Claude-exklusive Frontmatter-Felder (`disable-model-invocation`, `context`, `allowed-tools`, `hooks`, `model`, `agent`)
- `$ARGUMENTS` Substitution
- `!`command`` Syntax
- Plattform-spezifische Tool-Referenzen (z.B. "Use the `Skill` tool")

**Praxis-Empfehlung für Multi-Agent-Repos:**

```text
.claude/skills/    → Claude Code (kann erweiterte Features nutzen)
.agent/skills/     → Antigravity (nur Standard-Format)
.agents/skills/    → Gemini CLI / Codex / Cursor / Copilot (Standard-Format)
```

Wenn ein Skill beide Plattformen bedienen soll, keine Claude-exklusiven Frontmatter-Felder verwenden. Unbekannte Felder werden von Antigravity stillschweigend ignoriert — führen aber zu totem Code im Frontmatter.

### Wann welche Plattform-Features nutzen?

| Szenario | Empfehlung |
| --- | --- |
| Skill soll überall funktionieren | Nur `name` + `description`, Standard-Body |
| Deploy-Workflow (gefährlich, manuell) | Claude: `disable-model-invocation: true` |
| Recherche-Task (context-schwer) | Claude: `context: fork` + `agent: Explore` |
| Hintergrundwissen ohne User-Invocation | Claude: `user-invocable: false` |
| Read-only Analyse | Claude: `allowed-tools: Read, Grep, Glob` |
| Parametrisierter Workflow | Claude: `$ARGUMENTS` |
| Live-Daten in Skill einbetten | Claude: `!`command`` |
| Simple Wissens-Kapsel | Beide: Standard-Format reicht |

---

## 15. MCP-Server — Model Context Protocol

### Was es ist

MCP (Model Context Protocol) ist ein **offener Standard** für die Anbindung externer Tools und Datenquellen an Claude Code. Statt Daten manuell in den Context zu kopieren, verbindet sich Claude direkt mit APIs, Datenbanken, Dateisystemen und Services.

> *"MCP servers give Claude direct access to external tools and data sources — GitHub PRs, databases, APIs — without you needing to copy-paste context into the conversation."*

### Architektur

```text
Claude Code   ←→   MCP Client (built-in)   ←→   MCP Server   ←→   Externe Ressource
                                                    │
                                              ┌─────┴──────┐
                                              │  Tools      │  (Actions die Claude ausführt)
                                              │  Resources  │  (Daten die Claude liest)
                                              │  Prompts    │  (Vorgefertigte Prompt-Templates)
                                              └─────────────┘
```

### Server hinzufügen

```bash
# Syntax:
claude mcp add <name> -- <command> [args...]

# Beispiele:
claude mcp add github -- gh copilot mcp
claude mcp add filesystem -- npx @anthropic/mcp-filesystem /path/to/docs
claude mcp add postgres -- npx @anthropic/mcp-postgres $DATABASE_URL
claude mcp add brave-search -- npx @anthropic/mcp-brave-search
```

### Server verwalten

```bash
# Alle konfigurierten Server auflisten:
claude mcp list

# Server entfernen:
claude mcp remove <name>

# Server-Status prüfen (in einer Session):
/mcp
```

### Scope-Ebenen

MCP-Server können auf verschiedenen Ebenen konfiguriert werden:

| Scope | Flag | Speicherort | Geteilt? |
| --- | --- | --- | --- |
| **Projekt** | `--scope project` | `.claude/settings.json` | Ja (Git) |
| **User** | `--scope user` | `~/.claude/settings.json` | Nein |
| **Projekt-lokal** | `--scope project-local` | `.claude/settings.local.json` | Nein |

```bash
# Projekt-weiter Server (Team teilt ihn via Git):
claude mcp add github --scope project -- gh copilot mcp

# Nur für dich:
claude mcp add my-db --scope user -- npx @anthropic/mcp-postgres $MY_DB_URL
```

### Populäre MCP-Server

| Server | Paket | Typischer Einsatz |
| --- | --- | --- |
| **GitHub** | `gh copilot mcp` | PRs, Issues, Repos, Code Search |
| **Filesystem** | `@anthropic/mcp-filesystem` | Zugriff auf Ordner außerhalb des Repos |
| **PostgreSQL** | `@anthropic/mcp-postgres` | DB-Queries, Schema-Inspection |
| **Brave Search** | `@anthropic/mcp-brave-search` | Web-Suche aus Claude heraus |
| **Puppeteer** | `@anthropic/mcp-puppeteer` | Browser-Automation, Screenshots |
| **SQLite** | `@anthropic/mcp-sqlite` | Lokale DB-Abfragen |
| **Sentry** | `@sentry/mcp-server` | Error-Tracking, Issue-Triage |

Vollständige Liste: [MCP Server Registry](https://github.com/modelcontextprotocol/servers)

### Eigene MCP-Server bauen

Claude kann MCP-Server direkt schreiben:

```text
Build an MCP server that connects to our internal REST API at https://api.example.com
It should expose:
- A "search-users" tool that queries /api/users?q=
- A "get-user" tool that fetches /api/users/:id
```

MCP-Server sind Node.js- oder Python-Prozesse die über stdio kommunizieren. Das Protokoll ist standardisiert und gut dokumentiert.

### Best Practices

- **Projekt-MCP in `.claude/settings.json`** — damit das Team die gleichen Server nutzt
- **Credentials nie in Settings** — Umgebungsvariablen verwenden (`$DATABASE_URL`, `$GITHUB_TOKEN`)
- **Least Privilege** — nur die Server anbinden die tatsächlich gebraucht werden
- **MCP statt CLI-Workarounds** — `claude mcp add github` statt manuelles `gh api` Scripting
- **Test mit `/mcp`** — nach dem Setup prüfen ob alle Server healthy sind

---

## 16. Permissions & `settings.json`

### Was es ist

Claude Code hat ein **gestuftes Permission-System** das kontrolliert, welche Tools und Aktionen erlaubt, verboten oder approval-pflichtig sind. Permissions werden in `settings.json` gespeichert und können per `/permissions` interaktiv verwaltet werden.

### Permission-Ebenen

| Ebene | Datei | Wer kontrolliert |
| --- | --- | --- |
| **Enterprise** | Managed Policy (IT-Admin) | Organisations-Admins |
| **User** | `~/.claude/settings.json` | Du (global, alle Projekte) |
| **Project** | `.claude/settings.json` | Team (via Git) |
| **Project-Local** | `.claude/settings.local.json` | Du (nur dieses Projekt) |

**Priorität:** Enterprise > User > Project. Höhere Ebenen können niedrigere überschreiben.

### Quick Setup

```text
# In Claude Code:
/permissions
```

### Allow/Deny-Syntax

Permissions verwenden **Glob-Patterns** um Tools gezielt freizugeben oder zu sperren:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm test)",
      "Bash(npm run lint)",
      "Bash(npm run build)",
      "Bash(git *)",
      "Read(*)",
      "Write(src/**)",
      "MCP(github:*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl *)",
      "Bash(wget *)",
      "Write(.env*)",
      "Write(*.lock)"
    ]
  }
}
```

### Permission-Patterns

| Pattern | Bedeutung |
| --- | --- |
| `Bash(npm test)` | Exakt diesen Befehl erlauben |
| `Bash(npm run *)` | Alle npm-run-Befehle erlauben |
| `Bash(git *)` | Alle Git-Befehle erlauben |
| `Read(*)` | Alle Dateien lesen erlauben |
| `Write(src/**)` | Nur in `src/` schreiben erlauben |
| `MCP(github:*)` | Alle GitHub-MCP-Tools erlauben |
| `Skill(deploy *)` | Deploy-Skill sperren/erlauben |

### Trust-Modi

Claude Code kann mit verschiedenen Trust-Leveln gestartet werden:

```bash
# Standard: Fragt bei jedem potenziell gefährlichen Tool
claude

# Alles erlauben (für CI/CD oder vertrauenswürdige Umgebungen):
claude --dangerously-skip-permissions

# Headless Mode (für Automation/Scripts):
claude -p "Run all tests" --allowedTools "Bash(npm test)" --json
```

### Session-Permissions

Während einer Session kannst du Permissions anpassen:

```text
# Anzeigen was aktuell erlaubt/verboten ist:
/permissions

# Temporär erlauben (nur diese Session):
Allow Bash(docker *) for this session

# Dauerhaft erlauben:
Always allow Bash(docker *)
```

### Hook-Registrierung in `settings.json`

Neben Permissions ist `settings.json` auch der einzige Ort, an dem Hooks registriert werden. Ein Hook-Script ohne Eintrag hier ist **Dead Code**.

```json
{
  "permissions": {
    "allow": ["Bash(npm test)", "Bash(git *)"],
    "deny": ["Bash(rm -rf *)", "Write(.env*)"]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": ".claude/hooks/protect-files.sh" }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [{ "type": "command", "command": ".claude/hooks/run-lint.sh" }]
      }
    ]
  }
}
```

| Hook-Typ | Wann | Typischer Einsatz |
| --- | --- | --- |
| `PreToolUse` | Vor dem Tool-Aufruf | File-Schutz, Validierung |
| `PostToolUse` | Nach dem Tool-Aufruf | Linting, Logging, Formatierung |
| `PreCompact` | Vor Context-Komprimierung | Wichtige Infos sichern |

### Best Practices

- **Project-level `settings.json` ins Git** — Team-weite Konsistenz
- **Deny vor Allow** — sicherheitsrelevante Befehle explizit sperren
- **Credentials-Files schützen** — `Deny: Write(.env*)`, `Write(*secret*)`
- **CI-Pipelines:** `--allowedTools` Whitelist statt `--dangerously-skip-permissions`
- **Neue MCP-Server:** beim ersten Einsatz Permissions prüfen
- **Nach Hook-Script erstellen:** sofort in `settings.json` registrieren, sonst läuft der Hook nie

---

## 17. Multi-Root Workspaces & Monorepos

### Was es ist

Claude Code kann mit **mehreren Projekt-Ordnern** gleichzeitig arbeiten. Das ist relevant für Monorepos, Cross-Repo-Arbeit, und wenn Docs oder Configs in einem separaten Ordner liegen.

### Ordner hinzufügen

```bash
# Zusätzlichen Ordner zur Session hinzufügen:
claude --add-dir /path/to/other-project

# Mehrere Ordner:
claude --add-dir ../shared-lib --add-dir ../docs
```

### CLAUDE.md in Unterverzeichnissen

In einem Monorepo kann jedes Paket ein eigenes `CLAUDE.md` haben:

```text
monorepo/
├── CLAUDE.md                    # Root-Level: Globale Regeln
├── packages/
│   ├── frontend/
│   │   └── CLAUDE.md            # Frontend-spezifische Regeln
│   ├── backend/
│   │   └── CLAUDE.md            # Backend-spezifische Regeln
│   └── shared/
│       └── CLAUDE.md            # Shared-Library-Regeln
```

**Lade-Verhalten:**

- Root-CLAUDE.md wird **immer** geladen
- Unterverzeichnis-CLAUDE.md-Dateien werden **on-demand** geladen, wenn Claude dort Dateien liest
- Regeln werden **additiv** kombiniert (kein Override)

### Rules in Monorepos

Pfad-spezifische Rules eignen sich besonders gut für Monorepos:

```markdown
<!-- .claude/rules/frontend.md -->
---
paths: ["packages/frontend/**"]
---

# Frontend Rules
- Use React 19 with Server Components
- CSS Modules, no Tailwind
- All components must have unit tests
```

```markdown
<!-- .claude/rules/backend.md -->
---
paths: ["packages/backend/**"]
---

# Backend Rules
- Express.js with TypeScript
- Zod for request validation
- Integration tests with supertest
```

### Skills-Discovery in Monorepos

Claude Code durchsucht verschachtelte Verzeichnisse nach Skills:

```text
monorepo/
├── .claude/skills/              # Root Skills (für alle Packages)
├── packages/
│   ├── frontend/.claude/skills/ # Frontend-spezifische Skills
│   └── backend/.claude/skills/  # Backend-spezifische Skills
```

Claude sieht alle Skills und entscheidet kontextbasiert welche relevant sind.

### Cross-Repo-Arbeit

Für Arbeit über Repo-Grenzen hinweg:

```bash
# Hauptprojekt + API-Spec-Repo + Shared Types:
claude --add-dir ../api-spec --add-dir ../shared-types
```

Claude kann dann Dateien aus allen Ordnern lesen und bearbeiten, wobei die CLAUDE.md-Dateien jedes Ordners respektiert werden.

### Best Practices

- **Root-CLAUDE.md minimal halten** — nur Regeln die für alle Packages gelten
- **Package-spezifisches in Unterverzeichnis-CLAUDE.md** — nicht alles in Root stopfen
- **`paths:`-Scoping in Rules** — verhindert dass Backend-Regeln auf Frontend-Code angewandt werden
- **`--add-dir` statt Symlinks** — sauberer und Claude versteht den Context besser
- **Nur hinzufügen was nötig ist** — jeder zusätzliche Ordner verbraucht Discovery-Budget

---

## 18. GitHub Copilot in VS Code — Optimales Setup

> Quelle: [VS Code Copilot Customization](https://code.visualstudio.com/docs/copilot/customization/overview) und [Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) (Stand: Februar 2026)

### Übersicht: Customization-Ebenen

VS Code Copilot kennt diese Schichten, von "immer aktiv" bis "on-demand":

| Zweck | Mechanismus | Wann aktiv |
| --- | --- | --- |
| Coding-Standards für das ganze Repo | Always-on instructions | Jede Chat-Anfrage |
| Unterschiedliche Regeln je Dateityp | File-based instructions (`*.instructions.md`) | Wenn Dateiten den `applyTo`-Glob matchen |
| Wiederholbare Tasks als Slash-Command | Prompt files (`*.prompt.md`) | Manuell per `/command` |
| Mehrere AI-Tools, ein Set Regeln | `AGENTS.md` | Jede Chat-Anfrage (multi-tool) |
| Spezialisierter Agent für eine Rolle | Custom agents | Wenn ausgewählt oder delegiert |
| Externe APIs / Datenbanken | MCP | Wenn Tool relevant |
| Automation an Agent-Lifecycle-Punkten | Hooks | Beim konfigurierten Trigger |

**Empfehlung für den Einstieg:**
1. `/.github/copilot-instructions.md` für projekt-weite Standards
2. `.github/instructions/*.instructions.md` für sprach-/technologie-spezifische Regeln
3. `.github/prompts/*.prompt.md` für wiederkehrende Workflows (Review, Feature-Plan etc.)

### Typ 1: Always-On Instructions

Always-on instructions werden **automatisch in jede Chat-Anfrage** geladen — kein manuelles Anhängen nötig.

#### `copilot-instructions.md`

Datei: `.github/copilot-instructions.md`

- Wird für **alle Chat-Anfragen** im Workspace geladen (Inline Chat, Ask, Agent, Code Review)
- Enthält: Coding-Standards, Tech-Stack, Architektur-Patterns, Security-Requirements
- **Länge:** Concise halten — je länger, desto mehr Rauschen im Context
- Inhalt: nur was der AI nicht aus dem Code ablesen kann

Minimales Starter-Template:

```markdown
# Copilot Instructions

## Project Context

[Project Name] — [1-sentence description]. [Stack/framework].

## Always Do

- [Rule 1 that Copilot cannot infer from code]
- [Rule 2]

## Never Do

- [Hard prohibition 1]
- [Hard prohibition 2]

## Key Files

| File | Purpose |
| --- | --- |
| `src/main.ts` | Entry point |
| `config/` | All configuration |
```

#### `AGENTS.md`

Datei: `AGENTS.md` (Repo-Root)

- Wird von **VS Code Copilot, OpenAI Codex, Gemini CLI, Cursor** gleichermaßen gelesen
- Ideal wenn mehrere AI-Tools im Repo eingesetzt werden — ein Ort für alle
- Experimentell: nested `AGENTS.md` in Subordnern (via `chat.useNestedAgentsMdFiles` Setting)
- Setting: `chat.useAgentsMdFile` (default: enabled)

#### `CLAUDE.md`

VS Code liest seit 2026 auch `CLAUDE.md` und `.claude/rules/*.md` als Always-On-Instructions.

- Setting: `chat.useClaudeMdFile`
- `.claude/rules/` nutzt `paths:` statt `applyTo:` für Glob-Matching (Claude Rules Format)
- Vorteil: Ein gemeinsames Setup für Claude Code + VS Code Copilot ohne Duplizierung

**Priorität bei Konflikten:** Personal > Repository (copilot-instructions.md / AGENTS.md) > Organization

### Typ 2: File-Based Instructions (`.instructions.md`)

Dateien: `.github/instructions/*.instructions.md`

File-based instructions werden **nur geladen wenn der Agent an Dateien arbeitet die dem Glob-Pattern matchen**. Ideal für sprachspezifische Konventionen oder Framework-Patterns.

#### Frontmatter-Felder

| Feld | Required | Beschreibung |
| --- | --- | --- |
| `name` | Nein | Anzeigename im VS Code Diagnostics-View und beim Hover |
| `description` | Nein | Kurzbeschreibung (auch für semantisches Matching ohne `applyTo`) |
| `applyTo` | Nein | Glob-Pattern. Ohne dieses Feld: **nicht automatisch geladen** (nur manuell) |

> **Wichtig:** Ohne `applyTo` wird die Datei niemals automatisch angewendet. Wenn kein Glob passt aber semantisch Ähnlichkeit besteht, kann die `description` als Fallback-Trigger wirken.

#### Dateiformat

```markdown
---
name: 'TypeScript Standards'
description: 'Type safety and naming conventions for TypeScript files'
applyTo: "**/*.ts,**/*.tsx"
---

# TypeScript Standards

- Prefer `interface` over `type` for object shapes
- Use `unknown` instead of `any`
- All public functions must have JSDoc comments
```

#### Best Practices

- Granular statt monolithisch: eine Datei pro Thema (Frontend, Backend, Tests, Docs)
- `name` + `description` immer ausfüllen — verbessert die VS Code Diagnostics-UI
- Setting: `chat.includeApplyingInstructions` muss enabled sein (default: true)
- Debugging: Chat View → Rechtsklick → Diagnostics zeigt alle geladenen Instruction-Files

### Typ 3: Prompt Files (`.prompt.md`) — Slash Commands

Dateien: `.github/prompts/*.prompt.md`

Prompt Files sind **manuell aufrufbare Slash-Commands** im Chat. Sie kapseln wiederkehrende Tasks als vordefinierte Prompts.

#### Frontmatter-Felder

| Feld | Beschreibung |
| --- | --- |
| `name` | Slash-Command-Name (default: Dateiname) |
| `description` | Tooltip-Text im Command-Picker |
| `argument-hint` | Placeholder-Text im Chat-Input, z.B. `describe the feature` |
| `agent` | Agent für den Prompt: `ask`, `agent`, `plan`, oder Custom Agent Name |
| `model` | Modell-Override (optional) |
| `tools` | Whitelist der verfügbaren Tools für diesen Prompt |

#### Beispiel: Feature-Plan Prompt

```markdown
---
name: 'new-feature'
description: 'Plan a new feature before any code is written'
agent: plan
argument-hint: 'describe the feature'
---

Create a structured implementation plan for: ${input:feature:describe the feature}

## Constraints
- [Project-specific constraint 1]
- [Project-specific constraint 2]

## Plan Structure
1. Goal — one sentence
2. Files to change
3. Test plan
```

#### Beispiel: Pre-Commit Review Prompt

```markdown
---
name: 'review-changes'
description: 'Review current changes for project rule compliance'
agent: ask
---

Review the current changes in `#changes` for compliance:

- [Rule A]
- [Rule B]

Report each violation with file + line + fix suggestion.
```

#### Aufruf

- Im Chat: `/review-changes` oder `/new-feature`
- Command Palette: `Chat: Run Prompt`
- Editor: Play-Button in der Prompt-Datei (zum Testen)

#### Agent Skills vs. Prompt Files

| Feature | Agent Skills (`.agents/skills/`) | Prompt Files (`.github/prompts/`) |
| --- | --- | --- |
| Aufruf | `/skill-name` oder automatisch | `/command` manuell |
| Multi-Tool | ✅ Claude, Codex, Copilot, Cursor | VS Code Copilot only |
| Tools-Whitelist | `allowed-tools:` | `tools:` |
| Agent wählbar | `agent:` (Claude-Felder) | `agent:` |
| Argumente | `$ARGUMENTS` | `${input:name}` Variablen |
| Semantisches Triggern | ✅ (automatisch) | ❌ (immer manuell) |

**Faustregel:** Agent Skills für plattformübergreifende wiederverwendbare Workflows. Prompt Files für VS-Code-spezifische oder Copilot-optimierte Tasks.

### Typ 4: Custom Agents

Dateien: `.github/agents/*.md` (oder via VS Code UI angelegt)

Custom Agents definieren eine **spezialisierte Persona** mit eigenen Tools, Modell und Instruktionen. Ein Custom Agent kann als Subagent delegiert werden.

```markdown
---
name: 'security-reviewer'
description: 'Reviews code for security vulnerabilities'
tools: ["read_file", "grep", "run_command"]
model: claude-sonnet
---

You are a senior security engineer. Review code for:
- Injection vulnerabilities (XSS, SQL injection)
- Authentication and authorization flaws
- Hardcoded secrets

Output severity-classified findings with exact file:line references.
```

### Checkliste: Neues Repo aufsetzen

```text
☐ .github/copilot-instructions.md erstellt (projekt-weite Standards)
☐ .github/instructions/ angelegt mit *.instructions.md Dateien
  ☐ Alle instruction files haben name + description + applyTo Frontmatter
  ☐ applyTo Glob-Pattern korrekt (ohne applyTo: wird Datei nie automatisch geladen)
☐ .github/prompts/ angelegt mit *.prompt.md Dateien
  ☐ Review-Prompt (agent: ask, read-only)
  ☐ Feature-Plan-Prompt (agent: plan)
☐ AGENTS.md im Root (wenn mehrere AI-Tools eingesetzt werden)
☐ Diagnostics geprüft (Chat View → Rechtsklick → Diagnostics)
```

### Anti-Patterns

| Anti-Pattern | Problem | Fix |
| --- | --- | --- |
| `*.instructions.md` ohne `applyTo:` | Datei wird niemals automatisch geladen | `applyTo: "**/*"` für immer-aktiv, oder spezifischer Glob |
| Instruction-Datei ohne `name`/`description` | Schlechte Diagnostics-UI, kein semantisches Matching | Frontmatter ergänzen |
| `copilot-instructions.md` zu lang | Wichtige Regeln gehen im Rauschen unter | Pfad-spezifische Regeln in `*.instructions.md` auslagern |
| Provider-Adressform pauschal hardcoded | Falsche Tonalität wenn mehrere Provider variieren | Provider-spezifische Regel mit Ausnahmen dokumentieren |
| Duplikate zwischen `copilot-instructions.md` und `AGENTS.md` | Inkonsistenz bei Änderungen | In `copilot-instructions.md` auf `AGENTS.md` verweisen, nicht duplizieren |
| Hook-Script ohne VS Code Settings | Script wird nie ausgeführt — stille Fehlfunktion | In VS Code `settings.json` registrieren |

---

## 19. Kilo Code — Optimales Setup

> Quelle: [kilo.ai/docs/customize](https://kilo.ai/docs/customize) und [kilo.ai/docs/customize/custom-rules](https://kilo.ai/docs/customize/custom-rules) (Stand: Februar 2026)

### Überblick

Kilo Code ist ein Open-Source AI Coding Agent (VS Code Extension + CLI, Fork von OpenCode). Er unterstützt 500+ Modelle, hat 15k+ GitHub Stars und ist #1 auf OpenRouter. Kilo verwendet `AGENTS.md` als primären Standard für Projektkontext und hat zusätzlich ein eigenes `.kilocode/`-basiertes Regelwerk.

### Konfigurations-Ebenen (Priorität, hoch → niedrig)

| Priorität | Datei/Verzeichnis | Zweck |
| --- | --- | --- |
| 1 (höchste) | `.kilocode/rules-{mode}/` | Mode-spezifische Regeln (Code, Architect, Debug, Ask) |
| 2 | `.kilocode/rules/*.md` | Projekt-Regeln — **wichtigste per-Projekt-Konfiguration** |
| 3 | `AGENTS.md` | Universeller Standard aller AI Coding Tools |
| 4 | `~/.kilocode/rules/` | Globale User-Regeln (nicht im Repo) |
| 5 (niedrigste) | Custom Instructions | IDE-global, nicht versionierbar |

**Key Insight:** `AGENTS.md` wird von Kilo Code nativ gelesen (Priorität 3). Für stärkere Regeln — die `AGENTS.md` überschreiben — `.kilocode/rules/coding-standards.md` nutzen.

### Projekt-Regeln: `.kilocode/rules/`

Dateien in `.kilocode/rules/*.md` werden **bei jeder Anfrage** geladen (Priorität 2, höher als `AGENTS.md`).

```text
project/
├── .kilocode/
│   └── rules/
│       ├── coding-standards.md    ← Haupt-Regelwerk
│       ├── security.md            ← Sicherheitsrichtlinien
│       └── naming-conventions.md  ← Benennungskonventionen
├── AGENTS.md                      ← Universeller Kontext (Priorität 3)
└── ...
```

#### Regelformat

Kilo Rules verwenden YAML-Frontmatter mit `trigger: always` für dauerhaft aktive Regeln:

```markdown
---
trigger: always
---

# Coding Standards

- Minimal changes only — don't touch unrelated files
- No runtime frameworks, no CDN imports
- UTF-8 without BOM on all files
```

#### Mode-spezifische Regeln

Für Regeln die nur in bestimmten Modi gelten:

```text
.kilocode/rules-code/     ← Nur im Code-Modus
.kilocode/rules-architect/ ← Nur im Architect-Modus
.kilocode/rules-debug/    ← Nur im Debug-Modus
```

### AGENTS.md — Universeller Kontext

Kilo Code liest `AGENTS.md` nativ (Priorität 3). Das Template enthält bereits eine fertige `AGENTS.md`. Kilo schützt die Datei vor versehentlichen Änderungen durch den Agent (write-protected by default).

Die Konfigurationshierarchie in Kilo im Überblick — `.kilocode/rules/` hat Vorrang:

```text
.kilocode/rules-{mode}/    ←  höchste Priorität (mode-spezifisch)
.kilocode/rules/           ←  Projekt-Regeln
AGENTS.md                  ←  Universal-Kontext
~/.kilocode/rules/         ←  User-globale Regeln
Custom Instructions        ←  IDE-global (niedrigste Priorität)
```

### Modi (Modes)

Kilo Code hat 4 eingebaute Modi, zwischen denen man wechseln kann:

| Modus | Zweck | Typische Tools |
| --- | --- | --- |
| **Code** | Code schreiben und editieren | File tools, Terminal, Browser |
| **Architect** | Planen, analysieren, entwerfen | Read-only Tools, kein Code schreiben |
| **Debug** | Fehler finden und beheben | Diagnostics, Terminal, selective writes |
| **Ask** | Questions beantworten ohne Änderungen | Read-only |

Eigene Modi können mit Custom Modes erstellt werden — nützlich für projektspezifische Workflows (z.B. `review`, `doc-writer`, `migration`).

### `.kilocodeignore` — Dateien ausschließen

Ähnlich wie `.gitignore` — verhindert dass Kilo bestimmte Dateien liest oder modifiziert:

```text
# .kilocodeignore
.env
credentials.json
secrets/*.txt
dist/
```

### Skills & Workflows

Kilo Code unterstützt denselben Agent Skills Open Standard wie Claude Code und Antigravity:

- **Skills**: `.kilocode/skills/<name>/SKILL.md` (Kilo-spezifisch) oder `.agents/skills/<name>/SKILL.md` (universal, empfohlen)
- **Workflows**: Kilo hat ein eigenes Workflow-System (`kilo.ai/docs/customize/workflows`) für automatisierte Mehrstufen-Tasks

Das Template-Repo enthält alle Skills bereits im universellen `.agents/skills/`-Format — diese funktionieren mit Kilo Code ohne weitere Anpassung.

### Migration: Memory Bank → AGENTS.md

Kilo hat das ältere Memory Bank Feature zugunsten von `AGENTS.md` deprecated. Falls du ein altes Kilo-Projekt migrierst:

```bash
# Memory Bank Inhalte ansehen:
ls .kilocode/rules/memory-bank/

# Inhalte nach AGENTS.md migrieren (manuell oder per Kilo):
# "Migrate my memory bank content to AGENTS.md"
```

### Empfohlenes Setup (5 Minuten)

1. **`AGENTS.md` befüllen** — Projektname, Stack, Constraints, verbotene Patterns
2. **`.kilocode/rules/coding-standards.md` befüllen** — Stack-spezifische Regeln (Priorität 2, überschreibt AGENTS.md)
3. **Mode-spezifische Regeln** (optional) — `.kilocode/rules-architect/` für Architekt-Kontext
4. **`.kilocodeignore` anlegen** — Secrets, Build-Outputs, Credentials ausschließen
5. **Skills nutzen** — universelle Skills in `.agents/skills/` funktionieren direkt

### Anti-Patterns

| Anti-Pattern | Problem | Besser |
| --- | --- | --- |
| Nur `AGENTS.md` ohne `.kilocode/rules/` | Niedrigste Priorität, wird von anderen Quellen überschrieben | `.kilocode/rules/coding-standards.md` als primäres Regelwerk |
| Secrets in `AGENTS.md` | Kilo liest die Datei bei jeder Anfrage — Leak-Risiko | `.kilocodeignore` nutzen, Secrets nie in Konfigurationsdateien |
| Mode-spezifische Regeln für alles | Overhead, schwer wartbar | Nur für echte Mode-Unterschiede nutzen |
| Memory Bank weiter nutzen | Deprecated — wird ggf. entfernt | Zu `AGENTS.md` migrieren |

---

## Quellen

- [Claude Code — Memory Management](https://code.claude.com/docs/en/memory)
- [Claude Code — Best Practices](https://code.claude.com/docs/en/best-practices)
- [Claude Code — Skills](https://code.claude.com/docs/en/skills)
- [Claude Code — Hooks](https://code.claude.com/docs/en/hooks-guide)
- [Claude Code — Overview](https://code.claude.com/docs/en/overview)
- [Claude Code — MCP](https://code.claude.com/docs/en/mcp)
- [Claude Code — Permissions](https://code.claude.com/docs/en/permissions)
- [Claude Code — Settings](https://code.claude.com/docs/en/settings)
- [Model Context Protocol — Specification](https://modelcontextprotocol.io/)
- [MCP Server Registry](https://github.com/modelcontextprotocol/servers)
- [Google Antigravity — Skills](https://antigravity.google/docs/skills)
- [Gemini CLI — Skills](https://geminicli.com/docs/cli/skills/)
- [OpenAI Codex — Skills](https://developers.openai.com/codex/skills)
- [OpenAI Codex — AGENTS.md](https://developers.openai.com/codex/guides/agents-md)
- [Agent Skills Open Standard](https://agentskills.io/)
- [VS Code — Customize AI in VS Code (Overview)](https://code.visualstudio.com/docs/copilot/customization/overview)
- [VS Code — Use custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [VS Code — Use prompt files (slash commands)](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [VS Code — Create custom agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [VS Code — Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [VS Code — Hooks](https://code.visualstudio.com/docs/copilot/customization/hooks)
- [Kilo Code — Dokumentation (Übersicht)](https://kilo.ai/docs)
- [Kilo Code — Customize](https://kilo.ai/docs/customize)
- [Kilo Code — Custom Rules](https://kilo.ai/docs/customize/custom-rules)
- [Kilo Code — Custom Instructions](https://kilo.ai/docs/customize/custom-instructions)
- [Kilo Code — AGENTS.md](https://kilo.ai/docs/customize/agents-md)
- [Kilo Code — Workflows](https://kilo.ai/docs/customize/workflows)
- [Kilo Code — Skills](https://kilo.ai/docs/customize/skills)
- [Kilo Code — GitHub Repository](https://github.com/Kilo-Org/kilocode)
