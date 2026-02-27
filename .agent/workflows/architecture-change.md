---
trigger: when the user asks for architecture changes, baseline changes, or cross-cutting technical refactors
description: Controlled workflow for architecture-level changes with ADR requirement
---

# Workflow: Architecture Change

> For changes with long-term technical impact.

---

## When Is This Workflow Required?

- [FILL: Change to runtime baseline or target environment]
- Change to core rendering/state patterns
- Change to config architecture or global contracts
- Introduction of new cross-cutting technical mechanisms

---

## Phase 1 — Architecture Proposal

Document before writing code:

- Problem / context
- Architecture goals
- Options (at least 2)
- Trade-offs
- Risk / rollback plan
- Impact on existing files/workflows

---

## Phase 2 — ADR (Mandatory)

Create or update an ADR in `docs/decisions/`:

- Decision
- Rationale
- Consequences
- Migration notes (if applicable)

No architecture-level change may be finalized without an ADR entry.

---

## Phase 3 — Implementation

- Work in small, isolated steps
- Verify API/schema compatibility
- [FILL: Runtime compatibility guard or environment checks]
- No unnecessary side effects

---

## Phase 4 — Verification

- Smoke test + targeted regression
- [FILL: Baseline/environment validation]
- Verify affected flows in QA checklist

---

## Phase 5 — Documentation Sync

At a minimum, update:

- [FILL: `docs/ARCHITECTURE.md`]
- [FILL: `docs/CONFIG-REFERENCE.md` (if schema affected)]
- [FILL: Additional project-specific docs affected by architecture changes]
- `CHANGELOG.md`

---

## Completion

- [ ] ADR present
- [ ] Implementation + regression OK
- [ ] Documentation fully synced
- [ ] Risks/trade-offs clearly recorded
- [ ] Pre-commit checks passed
