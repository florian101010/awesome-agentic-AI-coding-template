---
name: release-readiness
description: Pre-release quality gate covering functional checks, baseline validation, and documentation integrity. Use before publishing a new version or tagging a release.
allowed-tools: Read, Grep, Glob, Edit, MultiEdit, Write, Bash
disable-model-invocation: true
---

# Release Readiness

Follow `.agent/workflows/release-readiness.md` strictly.

Execution requirements:

1. Confirm release scope/freeze.
2. Run full QA checklist and summarize results.
3. Validate WebView baseline + compatibility guard assumptions.
4. Run documentation drift check using doc-audit workflow.
5. Run `.githooks/pre-commit` before final recommendation.
6. Provide Go/No-Go result with explicit blockers.
