#!/usr/bin/env bash
set -euo pipefail

echo "[check-all] Running fill marker regression check"
bash scripts/check-fill-markers.sh .fill-marker-baseline

echo "[check-all] Running agent context sync check"
python3 scripts/check-agent-context-sync.py

echo "[check-all] Validating shell scripts with shellcheck when available"
if command -v shellcheck >/dev/null 2>&1; then
  find scripts .agent/scripts -type f -name '*.sh' -print0 | xargs -0 -r shellcheck -S warning
else
  echo "[check-all] WARNING: shellcheck not installed; skipping"
fi

echo "[check-all] Checking template health report freshness"
python3 scripts/template-health-report.py --check

echo "[check-all] OK"
