# Repository Optimization Implementation Plan

## Objective

Move from analysis to execution by implementing high-ROI reliability improvements in incremental phases.

## Phase Status

| Phase | Scope | Status | Outcome |
| --- | --- | --- | --- |
| Phase 1 | Add placeholder regression tooling | Completed | `scripts/check-fill-markers.sh` added as optional local tool; CI enforcement intentionally excluded (template ships with `[FILL:]` markers by design) |
| Phase 2 | Add canonical metadata source + sync checks | Completed | `project-context.example.json` and sync check script added |
| Phase 3 | Standardize quality command (`check-all`) | Completed | `scripts/check-all.sh` created as optional local runner; gracefully skips checks when preconditions are absent |
| Phase 4 | Add fully resolved example project profile | Completed | `docs/EXAMPLE-PROFILE.md` added |
| Phase 5 | Add health metrics reporting | Completed | Metrics generator + tracked report added |

## Implemented Components

1. **Placeholder regression tooling (optional local)**
   - `scripts/check-fill-markers.sh` — scan for regressions when adopters create a `.fill-marker-baseline`
   - No `.fill-marker-baseline` shipped in template (would fail template's own CI since it has `[FILL:]` markers by design)
   - No CI job — enforcement belongs in adopted repos, not the template itself

2. **Cross-agent context sync foundation**
   - `project-context.example.json`
   - `scripts/check-agent-context-sync.py` (skip in template mode, enforce when `project-context.json` exists)

3. **Unified quality gate command**
   - `scripts/check-all.sh` runs fill-marker checks (if baseline exists), context sync, shell script lint (if shellcheck available), and health report freshness.

4. **Reference fully configured profile**
   - `docs/EXAMPLE-PROFILE.md`

5. **Template health metrics**
   - `scripts/template-health-report.py`
   - `docs/TEMPLATE-HEALTH.md`

## Next Optional Enhancements

- Add generation commands that write synchronized sections directly into agent files from `project-context.json`.
- Add a strict mode where unresolved placeholders in required files are fully blocked for non-template repositories.
