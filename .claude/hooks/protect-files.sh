#!/bin/bash
# protect-files.sh
# Blocks Claude Code from modifying critical repository files without user consent.
#
# NOTE: During initial template setup, this hook blocks modifications to .agent/,
# .claude/, .github/, and AGENTS.md — the very files you need to customize.
# To complete setup, either:
#   1. Temporarily rename/disable this hook while filling [FILL:] markers, or
#   2. Use --allowedTools flag to bypass for specific files.
# Re-enable after setup is complete.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(
  ".env"
  "package-lock.json"
  ".git/"
  ".agent/"
  ".claude/"
  ".github/"
  "CLAUDE.md"
  "AGENTS.md"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'. Modifying this file is restricted by the repository's Claude hooks." >&2
    exit 2
  fi
done

exit 0
