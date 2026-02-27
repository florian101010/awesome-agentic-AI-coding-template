# Repository Optimization Implementation Plan

## Objective

Move from analysis to execution by implementing high-ROI reliability improvements in incremental phases.

## Phase Status

| Phase | Scope | Status | Outcome |
| --- | --- | --- | --- |
| Phase 1 | Add placeholder regression checks in CI | Completed | No-regression checker added with baseline and CI gate |
| Phase 2 | Add canonical metadata source + sync checks | Completed | `project-context.example.json` and sync check script added |
| Phase 3 | Standardize quality command (`check-all`) | Completed | `scripts/check-all.sh` created and wired into CI |
| Phase 4 | Add fully resolved example project profile | Completed | `docs/EXAMPLE-PROFILE.md` added |
| Phase 5 | Add health metrics reporting | Completed | Metrics generator + tracked report + freshness check added |

## Implemented Components

1. **Placeholder regression guardrail**
   - `scripts/check-fill-markers.sh`
   - `.fill-marker-baseline`
   - CI job in `.github/workflows/pr-checks.yml`

2. **Cross-agent context sync foundation**
   - `project-context.example.json`
   - `scripts/check-agent-context-sync.py` (skip in template mode, enforce when `project-context.json` exists)

3. **Unified quality gate command**
   - `scripts/check-all.sh` runs fill-marker checks, context sync, shell script lint (when available), and health report freshness.

4. **Reference fully configured profile**
   - `docs/EXAMPLE-PROFILE.md`

5. **Template health metrics**
   - `scripts/template-health-report.py`
   - `docs/TEMPLATE-HEALTH.md`

## Next Optional Enhancements

- Add generation commands that write synchronized sections directly into agent files from `project-context.json`.
- Add a strict mode where unresolved placeholders in required files are fully blocked for non-template repositories.
