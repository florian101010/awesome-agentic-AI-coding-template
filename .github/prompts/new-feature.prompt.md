---
name: 'new-feature'
description: 'Plan a new feature before any code is written'
agent: plan
argument-hint: 'Describe the feature you want to add'
---

Create a structured implementation plan for this feature request:

**Feature:** ${input:feature:describe the feature}

## Planning Constraints

Before writing the plan, verify:
- [FILL: Constraint 1 — e.g. "This is achievable with vanilla HTML/CSS/JS — no frameworks, no build step"]
- [FILL: Constraint 2 — e.g. "The target environment (WebView, mobile browser, etc.) supports the interaction model"]

## Plan Structure

1. **Goal** — one sentence: what this feature changes for the user
2. **Files to change** — list only the files that need edits (minimal footprint)
3. **Config impact** — does this require new config fields? If yes, specify schema additions
4. **Code additions** — list new functions/components; flag any security-sensitive operations (e.g. new innerHTML insertions)
5. **Test plan** — which tests or manual checks apply
6. **ADR needed?** — is this an architectural change that warrants an ADR in `docs/decisions/`?

Do NOT write any code yet — output the plan only.

