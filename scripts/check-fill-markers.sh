#!/usr/bin/env bash
set -euo pipefail

if ! command -v rg >/dev/null 2>&1; then
  echo "[fill-check] ERROR: rg (ripgrep) is not installed or not in PATH" >&2
  exit 1
fi

BASELINE_FILE="${1:-.fill-marker-baseline}"

if [[ ! -f "$BASELINE_FILE" ]]; then
  echo "[fill-check] ERROR: baseline file not found: $BASELINE_FILE" >&2
  exit 1
fi

count_fill_markers() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    echo 0
    return
  fi
  (rg -o "\[FILL:" "$file" 2>/dev/null || true) | wc -l | tr -d ' '
}

in_baseline() {
  local file="$1"
  rg -n "^${file//./\.}=" "$BASELINE_FILE" >/dev/null 2>&1
}

status=0

# 1) Validate tracked baseline entries do not regress
while IFS='=' read -r file expected; do
  [[ -z "${file:-}" ]] && continue
  [[ "${file:0:1}" == "#" ]] && continue

  current="$(count_fill_markers "$file")"

  if (( current > expected )); then
    echo "[fill-check] ERROR: $file has $current [FILL:] markers (baseline: $expected)" >&2
    status=1
  fi
done < "$BASELINE_FILE"

# 2) Detect new markdown files with [FILL:] that are not in baseline
while IFS= read -r file; do
  if in_baseline "$file"; then
    continue
  fi

  current="$(count_fill_markers "$file")"
  if (( current > 0 )); then
    echo "[fill-check] ERROR: $file contains $current [FILL:] markers but is not in baseline" >&2
    status=1
  fi
done < <(rg --files -g "*.md")

if (( status == 0 )); then
  echo "[fill-check] OK: no [FILL:] marker regressions detected"
fi

exit "$status"
