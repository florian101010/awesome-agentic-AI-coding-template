---
trigger: when preparing a release, milestone handoff, or formal QA sign-off
description: Pre-release quality gate workflow for the project
---

# Workflow: Release Readiness

> Final quality check before release or handoff.

---

## Phase 1 — Scope Freeze

- Define exactly which changes are included in the release.
- Mark open items as explicitly "out of scope."

---

## Phase 2 — Functional Acceptance

- Execute the project's full QA checklist.
- Document test results per section.
- Ensure no critical console errors.

---

## Phase 3 — Environment Validation

- [FILL: Target environment] baseline validated
- [FILL: Compatibility guard or runtime checks] validated
- [FILL: Platform-specific behavior — e.g. "Touch behavior and hover guards validated"]

---

## Phase 4 — Documentation Gate

Mandatory checks:

- [FILL: `docs/README.md`]
- [FILL: `docs/ARCHITECTURE.md`]
- [FILL: Additional project-specific docs to verify]
- `docs/decisions/` (ADR files, if relevant)
- `CHANGELOG.md`

Run `.agent/workflows/doc-audit.md` as the final drift check.

---

## Phase 5 — Go/No-Go Decision

Go only when:

- [ ] QA passed
- [ ] Documentation in sync
- [ ] No critical open issues
- [ ] Changelog complete
- [ ] Pre-commit checks passed
