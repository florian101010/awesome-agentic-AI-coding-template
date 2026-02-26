---
name: 'Documentation Rules'
description: 'Drift-free documentation guidelines and mandatory sync targets for docs/**/*.md files'
applyTo: "docs/**/*.md"
---

# Documentation Instructions

## Purpose

Use these rules when editing files under `docs/` to keep documentation drift-free and aligned with implementation.

## Core Rules

- Treat code/config as source of truth; update docs to match code, never vice versa without explicit requirement.
- Keep wording concise, factual, and implementation-aligned.
- Preserve existing document structure unless a structural change is explicitly needed.

## Mandatory Sync Targets

<!-- SETUP: List all docs that must stay in sync when code/architecture changes. -->

When behavior, architecture, or schema changes, update all affected files:

- `docs/README.md`
- `docs/ARCHITECTURE.md`
- `docs/CHANGELOG.md`
- [FILL: Add further doc paths relevant to your project]
- `docs/decisions/` (if architectural — create/update ADR file)

## Data Accuracy Checks

Before finalizing documentation changes:

- Verify any count or metric values against the actual source (config files, code).
- Ensure no leading `/` or `./` paths are introduced (if the project uses relative paths).

## Process

- Follow `.agent/workflows/doc-audit.md` for full drift audits.
- Keep release-relevant updates reflected in `CHANGELOG.md`.
- For architecture-level changes, ensure an ADR file exists in `decisions/`.
- Run `.githooks/pre-commit` before final handoff.

