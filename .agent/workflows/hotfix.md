---
trigger: when an urgent production issue needs immediate mitigation
description: Controlled hotfix workflow balancing speed and safety
---

# Workflow: Hotfix

> Fast fix under time pressure without losing governance.

---

## Phase 1 — Incident Triage

- Document the error pattern and impact
- Determine severity level
- Define minimum fix scope

---

## Phase 2 — Minimal Fix

- Apply only the smallest effective fix closest to the root cause
- Do not address side issues
- Respect existing patterns

---

## Phase 3 — Critical Smoke Test

At minimum:

- Affected flow works again
- No obvious regressions
- No new critical console errors

---

## Phase 4 — Mandatory Documentation

Required even for hotfixes:

- `CHANGELOG.md` with hotfix entry
- Affected reference docs (at minimum a brief note)
- ADR only if architecture is affected

---

## Phase 5 — Post-Hotfix Follow-up

- Capture open technical debt
- Plan a follow-up task for a sustainable solution if needed

---

## Hotfix DoD

- [ ] Incident mitigated
- [ ] Smoke test passed
- [ ] Changelog updated
- [ ] Follow-up documented
- [ ] Pre-commit checks passed
