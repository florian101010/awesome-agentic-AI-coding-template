#!/bin/bash
set -euo pipefail

PR_NUMBER="$1"

if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <PR_NUMBER>"
  exit 1
fi

echo "🔍 Init Paranoid Analysis for PR #$PR_NUMBER..."

# Set up temp directory
TMP_DIR=".agent/tmp"
mkdir -p "$TMP_DIR"
PR_STATUS="$TMP_DIR/pr_${PR_NUMBER}_status.json"
PR_DIFF="$TMP_DIR/pr_${PR_NUMBER}.diff"
URLS_FILE="$TMP_DIR/pr_${PR_NUMBER}_urls.txt"

# 1. Fetch Status (Mergeability)
echo "---------------------------------------------------"
echo "📡 Fetching PR Status..."
gh pr view "$PR_NUMBER" --json state,mergeable,baseRefName,headRefName,title > "$PR_STATUS"
cat "$PR_STATUS" | jq '{state, mergeable, title}'

MERGEABLE=$(jq -r .mergeable "$PR_STATUS")
if [ "$MERGEABLE" = "CONFLICTING" ]; then
  echo "❌ CRITICAL: PR is CONFLICTING. Rebase required."
  echo "Recommendation: STOP audit. Request rebase."
fi

# 2. Fetch Raw Diff
echo "---------------------------------------------------"
echo "📥 Fetching Raw Diff..."
gh pr diff "$PR_NUMBER" > "$PR_DIFF"
echo "Diff saved to $PR_DIFF ($(wc -l < "$PR_DIFF") lines)"

# 2.1 Check for Dirty Branch (Commit Hygiene)
echo "---------------------------------------------------"
echo "🧹 Checking for Dirty Branching..."
# Check if PR has > 10 commits (sign of dirty history) or merges from main
COMMIT_COUNT=$(gh pr view "$PR_NUMBER" --json commits --jq '.commits | length')
if [ "$COMMIT_COUNT" -gt 10 ]; then
  echo "⚠️  WARNING: High commit count ($COMMIT_COUNT). Check for unrelated changes."
else
  echo "✅ Commit count reasonable ($COMMIT_COUNT)."
fi

# 3. Enhanced Threat Scan
echo "---------------------------------------------------"
echo "🛡️ Scanning for Architecture Violations & Threats..."
# Expanded Red Patterns from workflow to match AGENTS.md rules for this repo
RED_PATTERNS="rm |eval |curl |wget |chmod 777|ghp_|ey[A-Za-z0-9]*|password|secret|token|\\<script src=\"http|localStorage|sessionStorage|postMessage"

if grep -rnE "$RED_PATTERNS" "$PR_DIFF"; then
  echo "❌ POTENTIAL THREATS FOUND (See above)"
else
  echo "✅ No obvious red flags found in diff text."
fi

# 4. [FILL: Project-specific content scan]
# Add regex patterns relevant to your project's conventions.
# Example: check for forbidden strings, hardcoded values, or style violations.
echo "---------------------------------------------------"
echo "🔎 Project-specific content scan..."
# YOUR_PATTERNS="\\bforbidden\\b|hardcodedValue"
# if grep -E '^\+[^+]' "$PR_DIFF" | grep -nE "$YOUR_PATTERNS"; then
#   echo "⚠️  PROJECT-SPECIFIC VIOLATIONS FOUND (See above)"
# else
#   echo "✅ No project-specific violations found."
# fi
echo "ℹ️  No project-specific patterns configured. Add your patterns to section 4."

# 5. External Asset Verification (URL Check)
echo "---------------------------------------------------"
echo "🔗 Verifying External URLs..."
# Extract URLs and check them (limit to 5 to avoid spam)
grep -oE 'https?://[^ ")\`]+' "$PR_DIFF" | head -n 5 | sort | uniq > "$URLS_FILE"
if [ -s "$URLS_FILE" ]; then
  while read -r url; do
    if curl --output /dev/null --silent --head --fail --max-time 5 "$url"; then
      echo "✅ URL OK: $url"
    else
      echo "❌ URL BROKEN: $url"
    fi
  done < "$URLS_FILE"
else
  echo "ℹ️  No URLs found to verify."
fi

# 6. Fetch Gemini AI Insights
echo "---------------------------------------------------"
echo "🤖 Fetching Gemini AI Reviews..."
python3 .agent/scripts/fetch_gemini_reviews.py "$PR_NUMBER"
GEMINI_REPORT="$TMP_DIR/pr_${PR_NUMBER}_gemini_report.md"
if [ -f "$GEMINI_REPORT" ]; then
  echo "✅ Gemini insights found and saved to $GEMINI_REPORT"
  # Optional: print a snippet
  grep -F -A 5 "🤖 **Gemini Analysis" "$GEMINI_REPORT" | grep -v -F "🤖 **Gemini Analysis" || echo "   (Detailed analysis available in the report file)"
else
  echo "⚪ No Gemini reviews found for this PR."
fi

echo "---------------------------------------------------"
echo "⚠️  Manual Logic Audit Needed."
echo "    1. Read $PR_DIFF"
echo "    2. Check for missing hover media queries"
echo "    3. Verify documentation matches code changes if applicable"
