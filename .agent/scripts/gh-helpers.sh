#!/bin/bash

# .agent/scripts/gh-helpers.sh
# Robust, non-interactive wrappers for GitHub CLI to prevent hanging in agent environments.

# PROJECT SETTINGS (Modify these if you use GitHub Projects for this repo)
# Currently set to generic placeholders because dotfiles metadata varies from this repo.
PROJECT_ID="YOUR_PROJECT_ID"
FIELD_ID="YOUR_FIELD_ID"
OWNER="[FILL: your-github-username-or-org]"  # Your GitHub username or org that owns the project board
PROJECT_NUM=1 # Update to your actual project number

# Function: post_pr_comment <pr_number> <comment_body>
# Posts a comment to a PR non-interactively.
post_pr_comment() {
  local pr="$1"
  local body="$2"

  if [[ -z "$pr" ]] || [[ -z "$body" ]]; then
    echo "Usage: post_pr_comment <pr_number> <comment_body>" >&2
    return 1
  fi

  echo "📡 Posting comment to PR #$pr..."
  if gh pr comment "$pr" --body "$body" < /dev/null; then
    echo "✅ Successfully commented on PR #$pr."
    return 0
  else
    echo "❌ Failed to comment on PR #$pr."
    return 1
  fi
}

# Function: set_project_completed_date <pr_number> [date]
# Synchronizes the "Completed Date" metadata field in GitHub Projects.
set_project_completed_date() {
  local pr_num="$1"
  local date="${2:-$(date +%Y-%m-%d)}"

  echo "📡 Synchronizing Project Metadata for PR #$pr_num..."

  if [[ "$PROJECT_ID" == "YOUR_PROJECT_ID" ]]; then
    echo "ℹ️  Project tracking not configured. Skipping metadata update."
    echo "   (Update PROJECT_ID, FIELD_ID, and PROJECT_NUM in gh-helpers.sh to enable)"
    return 0
  fi

  local item_id
  item_id=$(gh project item-list "$PROJECT_NUM" --owner "$OWNER" --format json --limit 1000 \
    | python3 -c "import json, sys; data=json.load(sys.stdin); \
        items=data.get('items', []); \
        match=[i['id'] for i in items if i.get('content', {}).get('number') == $pr_num]; \
        print(match[0]) if match else exit(1)" 2> /dev/null)

  if [[ $? -ne 0 || -z "$item_id" ]]; then
    echo "⚠️  Could not find PR #$pr_num in Project $PROJECT_NUM. Skipping metadata update."
    return 0
  fi

  if gh project item-edit --id "$item_id" --project-id "$PROJECT_ID" --field-id "$FIELD_ID" --date "$date" < /dev/null; then
    echo "✅ Metadata 'Completed Date' set to $date for PR #$pr_num."
  else
    echo "❌ Failed to update metadata for PR #$pr_num."
  fi
}

# Function: batch_set_project_completed_date <date> <pr_number1> <pr_number2> ...
# Batch updates multiple PRs with a specific completion date.
batch_set_project_completed_date() {
  local date="$1"
  shift
  local prs=("$@")

  echo "🔄 Starting batch metadata update for date: $date"
  for pr in "${prs[@]}"; do
    set_project_completed_date "$pr" "$date"
  done
  echo "✅ Batch update finished."
}

# Function: close_pr <pr_number> [optional_comment]
# Closes a PR non-interactively, optionally posting a final comment.
close_pr() {
  local pr="$1"
  local comment="$2"

  if [[ -z "$pr" ]]; then
    echo "Usage: close_pr <pr_number> [optional_comment]" >&2
    return 1
  fi

  if [[ -n "$comment" ]]; then
    post_pr_comment "$pr" "$comment"
  fi

  echo "🔒 Closing PR #$pr..."
  if gh pr close "$pr" < /dev/null; then
    echo "✅ Successfully closed PR #$pr."
    # Auto-sync metadata on close if desired (optional: could be set to current date)
    # set_project_completed_date "$pr"
    return 0
  else
    echo "❌ Failed to close PR #$pr."
    return 1
  fi
}

# Function: close_as_superseded <target_pr> <superior_pr>
# Standardized way to close a PR that has been replaced by a better implementation.
close_as_superseded() {
  local target="$1"
  local superior="$2"
  local msg="🔴 Closed as **Superseded**. The changes in this PR have been integrated into a more comprehensive implementation in #$superior. Thank you for the contribution!"

  close_pr "$target" "$msg"
}

# Function: close_as_duplicate <target_pr> <original_pr>
# Standardized way to close a PR that duplicates existing scope.
close_as_duplicate() {
  local target="$1"
  local original="$2"
  local msg="🔴 Closed as **Duplicate**. This PR covers the same scope as #$original. Further review will continue there."

  close_pr "$target" "$msg"
}
