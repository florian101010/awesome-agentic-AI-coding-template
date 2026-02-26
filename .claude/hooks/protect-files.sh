#!/bin/bash
# protect-files.sh
# Blocks Claude Code from modifying critical repository files without user consent.

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
