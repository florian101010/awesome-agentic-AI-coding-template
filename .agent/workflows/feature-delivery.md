---
trigger: when the user asks for a new feature or substantial behavior change
description: End-to-end workflow for delivering features with planning, implementation, QA, and documentation sync
---

# Workflow: Feature Delivery

> Standard process for feature delivery.
> Goal: ship quickly without quality or documentation drift.

---

## Phase 1 — Feature Brief

Capture before implementation:

- Problem / goal
- Non-goals (scope boundary)
- Affected components / steps
- Affected files
- Risks (UX, performance, compatibility)
- Acceptance criteria (testable)

---

## Phase 2 — Design & Data Model

1. Check config files first as Single Source of Truth.
2. Define new fields in config instead of hardcoding in templates.
3. Document schema changes directly in the config file's JSDoc header.
4. Assess impact on existing rendering helpers.

---

## Phase 3 — Implementation (in Increments)

Recommended order:

1. Data access / state update
2. Rendering
3. Interaction logic
4. Fallback / error handling
5. Polish (a11y, UX copy, [FILL: environment-specific behavior])

Rules:

- [FILL: Project-specific implementation rules — e.g. "No frameworks / no dependencies"]
- Relative paths only
- [FILL: Platform-specific rules — e.g. "Touch-first: touch-action, -webkit-tap-highlight-color, hover-guard"]
- [FILL: Baseline requirements — e.g. "Modern ES6+ within baseline (iOS 16+, WebView 110+)"]

---

## Phase 4 — QA

At minimum, execute:

- Relevant items from your project's QA checklist
- Smoke test for affected user flows
- Fallback behavior verification
- No errors in the console

---

## Phase 5 — Documentation Sync (Mandatory)

Update as needed:

- [FILL: `docs/README.md`]
- [FILL: `docs/ARCHITECTURE.md`]
- [FILL: Additional doc paths relevant to your project]
- `docs/decisions/` (create new ADR if architecturally relevant)
- `CHANGELOG.md`

Also run the audit workflow: `.agent/workflows/doc-audit.md`

---

## Phase 6 — Definition of Done (DoD)

- [ ] Feature meets acceptance criteria
- [ ] No relevant errors
- [ ] QA smoke test passed
- [ ] Documentation in sync
- [ ] Changelog updated
- [ ] No rule violations (paths, [FILL: project-specific rules])
- [ ] Pre-commit checks passed
