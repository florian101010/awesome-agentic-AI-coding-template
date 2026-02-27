#!/bin/bash
# protect-files.sh
# Blocks Claude Code from modifying files that are dangerous to edit autonomously.
#
# Protected:
#   .env            — secrets must never be written by an agent
#   package-lock.json — lockfile integrity; use npm install to update
#   .git/           — git internals should never be touched directly
#
# NOT protected (intentionally editable):
#   CLAUDE.md, AGENTS.md, GEMINI.md, .claude/, .agent/, .github/
#   These are the primary customization targets for this template.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(
  ".env"
  "package-lock.json"
  ".git/"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
  if [[ "$FILE_PATH" == *"$pattern"* ]]; then
    echo "Blocked: $FILE_PATH matches protected pattern '$pattern'. Modifying this file is restricted by the repository's Claude hooks." >&2
    exit 2
  fi
done

exit 0
