#!/usr/bin/env bash
# Unified quality gate — runs all checks and reports every failure before exiting.
# Does NOT use 'set -e' so that all checks run and all failures are visible.
set -uo pipefail

status=0

echo "[check-all] Running fill marker regression check"
bash scripts/check-fill-markers.sh .fill-marker-baseline || status=1

echo "[check-all] Running agent context sync check"
python3 scripts/check-agent-context-sync.py || status=1

echo "[check-all] Validating shell scripts with shellcheck when available"
if command -v shellcheck >/dev/null 2>&1; then
  paths=(scripts)
  [[ -d .agent/scripts ]] && paths+=(.agent/scripts)
  find "${paths[@]}" -type f -name '*.sh' -print0 | xargs -0 -r shellcheck -S warning || status=1
else
  echo "[check-all] WARNING: shellcheck not installed; skipping"
fi

echo "[check-all] Checking template health report freshness"
python3 scripts/template-health-report.py --check || status=1

if (( status != 0 )); then
  echo "[check-all] FAILED: one or more checks failed — see errors above" >&2
  exit 1
fi

echo "[check-all] OK"
