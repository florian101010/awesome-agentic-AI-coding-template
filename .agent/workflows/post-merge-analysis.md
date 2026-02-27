---
trigger: when a PR has been merged into master and requires a strict post-merge verification
description: Paranoid line-by-line full-scope post-merge verification workflow
---

# Workflow: Post-Merge Analysis

> For a paranoid, full-scope verification after a PR merge into the default branch. Prevents regressions, stealth commits, and documentation drift.

---

## Phase 1 — Repository Sync & Log Audit

- Checkout the default branch and `git pull origin <default-branch>`
- Run `git log -n 5 --oneline` to verify the merge commit and linked commits.
- Explicitly check the merge commit diff to rule out "stealth commits" (code that was not in the PR scope).

---

## Phase 2 — Code Syntax & Runtime Sanity

- Run syntax checks for all changed or critical files: [FILL: e.g. `node --check config/*.js`]
- Run unit tests if available: [FILL: e.g. `npm test`]
- If the project has a build step or linter, run it explicitly.

---

## Phase 3 — Zero Drift Validation

Validate that the code state matches the documentation:

- Check `CHANGELOG.md` — Is the merge documented?
- Check config files against [FILL: config reference doc] — Were new fields documented?
- Search for removed features/classes (e.g. `grep -r "feature-xyz" .`) and verify they are completely removed from code **and** docs.

---

## Phase 4 — Cross-Reference & Link Audit

- Ensure no dead internal links were generated in Markdown files (e.g. links to deleted or moved files).
- Check whether new components were added to the QA checklist (if applicable).

---

## Completion

- [ ] Repository on the latest default branch
- [ ] Merge commit diff exactly as expected (no stealth changes)
- [ ] Syntax and tests succeeded
- [ ] Documentation zero-drift confirmed (changelog, references)
- [ ] Local feature branch deleted (optional)
