#!/usr/bin/env bash
# Jules API Helper Script - COMPLETE COVERAGE
# Usage: jules-api.sh <action> <args...>
#
# Session Actions:
#   create-session <source> <prompt>   Create a new session/task
#   get-session <id>                   Get session details
#   delete-session <id>                Delete a session
#   list-sessions [count]              List recent sessions
#   send-message <id> <msg>            Send message to session
#   approve-plan <id>                  Approve a pending plan
#
# Activity Actions:
#   get-activities <id> [count]        Get session activities
#   get-artifacts <id>                 Get artifacts (diffs, bash output)
#
# Source Actions:
#   list-sources [count]               List connected repositories
#   get-source <source_id>             Get source details

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
JULES_KEY_FILE="$REPO_ROOT/.jules_key"
TMP_DIR="$REPO_ROOT/.agent/tmp"
API_BASE="https://jules.googleapis.com/v1alpha"

# Load API key
ENV_FILE="$REPO_ROOT/.env"
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

if [[ -z "${JULES_API_KEY:-}" ]]; then
  if [[ -f "$JULES_KEY_FILE" ]]; then
    JULES_KEY=$(tr -d '[:space:]' < "$JULES_KEY_FILE")
  else
    echo "❌ Error: Jules API key not found in .env (JULES_API_KEY) or at $JULES_KEY_FILE" >&2
    exit 1
  fi
else
  JULES_KEY="$JULES_API_KEY"
fi

# Common curl options
curl_opts=(-s --max-time 60 -H "X-Goog-Api-Key: $JULES_KEY")

usage() {
  echo "Usage: $(basename "$0") <action> [args...]"
  echo ""
  echo "Session Actions:"
  echo "  create-session <source> <prompt> [--auto-pr]  Create a new task"
  echo "  get-session <session_id>                      Get session details"
  echo "  delete-session <session_id>                   Delete a session"
  echo "  list-sessions [count]                         List sessions (default: 10)"
  echo "  send-message <session_id> <message|file>      Send message (string or file path)"
  echo "  approve-plan <session_id>                     Approve pending plan"
  echo ""
  echo "Activity Actions:"
  echo "  get-activities <session_id> [count]           Get activities (default: 5)"
  echo "  get-artifacts <session_id>                    Get diffs/bash output"
  echo ""
  echo "Source Actions:"
  echo "  list-sources [count]                          List connected repos"
  echo "  get-source <source_id>                        Get source details"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") create-session sources/github/owner/repo 'Fix the bug' --auto-pr"
  echo "  $(basename "$0") get-artifacts 16856078149969131243"
  echo "  $(basename "$0") approve-plan 16856078149969131243"
}

# ============================================================================
# SESSION ACTIONS
# ============================================================================

create_session() {
  local source="$1"
  local prompt="$2"
  local auto_pr="${3:-}"

  mkdir -p "$TMP_DIR"
  local payload_file
  payload_file="$TMP_DIR/jules_create_$(date +%s).json"

  # Build payload
  if [[ "$auto_pr" == "--auto-pr" ]]; then
    jq -n --arg src "$source" --arg p "$prompt" '{
            sourceContext: { source: $src },
            prompt: $p,
            automationMode: "AUTO_CREATE_PR"
        }' > "$payload_file"
  else
    jq -n --arg src "$source" --arg p "$prompt" '{
            sourceContext: { source: $src },
            prompt: $p
        }' > "$payload_file"
  fi

  local response
  response=$(curl "${curl_opts[@]}" -X POST \
    -H "Content-Type: application/json" \
    -d "@$payload_file" \
    "$API_BASE/sessions")

  rm -f "$payload_file"

  # Extract session ID from response
  local session_id
  session_id=$(echo "$response" | jq -r '.name // empty')

  if [[ -n "$session_id" ]]; then
    echo "✅ Session created: $session_id"
    echo "$response" | jq '{name, state, title}'
  else
    echo "Response: $response"
  fi
}

get_session() {
  local session_id="$1"
  curl "${curl_opts[@]}" "$API_BASE/sessions/$session_id" | jq '{
        state,
        title,
        prompt: .prompt[:500],
        automationMode,
        requirePlanApproval,
        output: {
            pullRequest: .output.pullRequest.url
        }
    }'
}

delete_session() {
  local session_id="$1"

  local response
  response=$(curl "${curl_opts[@]}" -X DELETE "$API_BASE/sessions/$session_id")

  if [[ "$response" == "{}" ]]; then
    echo "✅ Session $session_id deleted successfully"
  else
    echo "Response: $response"
  fi
}

list_sessions() {
  local count="${1:-10}"
  curl "${curl_opts[@]}" "$API_BASE/sessions?pageSize=$count" \
    | jq '.sessions[] | {id: .name, state, title, created: .createTime}'
}

send_message() {
  local session_id="$1"
  local message="$2"

  # Support reading message from file if argument is a valid file path
  if [[ -f "$message" ]]; then
    message=$(cat "$message")
  fi

  # Pre-check: Verify session is active
  local state
  state=$(curl "${curl_opts[@]}" "$API_BASE/sessions/$session_id" | jq -r '.state')

  if [[ "$state" == "COMPLETED" || "$state" == "FAILED" ]]; then
    echo "⚠️  WARNING: Session is $state. Attempting to send message anyway (API may hang/timeout)..." >&2
  fi

  mkdir -p "$TMP_DIR"
  local payload_file
  payload_file="$TMP_DIR/jules_message_$(date +%s).json"

  jq -n --arg msg "$message" '{"prompt": $msg}' > "$payload_file"

  local response
  response=$(curl "${curl_opts[@]}" -X POST \
    -H "Content-Type: application/json" \
    -d "@$payload_file" \
    "$API_BASE/sessions/$session_id:sendMessage")

  rm -f "$payload_file"

  if [[ "$response" == "{}" ]]; then
    echo "✅ Message sent successfully to session $session_id"
    echo "   Run 'get-activities $session_id' to see Jules's response"
  else
    echo "Response: $response"
  fi
}

approve_plan() {
  local session_id="$1"

  # Check if session is awaiting approval
  local state
  state=$(curl "${curl_opts[@]}" "$API_BASE/sessions/$session_id" | jq -r '.state')

  if [[ "$state" != "AWAITING_PLAN_APPROVAL" ]]; then
    echo "⚠️ Session is not awaiting plan approval (state: $state)" >&2
    return 1
  fi

  local response
  response=$(curl "${curl_opts[@]}" -X POST \
    -H "Content-Type: application/json" \
    -d '{}' \
    "$API_BASE/sessions/$session_id:approvePlan")

  if [[ "$response" == "{}" ]]; then
    echo "✅ Plan approved for session $session_id"
  else
    echo "Response: $response"
  fi
}

# ============================================================================
# ACTIVITY ACTIONS
# ============================================================================

get_activities() {
  local session_id="$1"
  local count="${2:-5}"
  curl "${curl_opts[@]}" "$API_BASE/sessions/$session_id/activities?pageSize=$count" \
    | jq --arg count "$count" '.activities | sort_by(.createTime) | reverse | .[:($count | tonumber)] | .[] | {
            time: .createTime,
            originator,
            type: (if .messageContent then "message" elif .progressUpdated then "progress" elif .planGenerated then "plan" elif .userMessaged then "user_message" elif .sessionCompleted then "completed" elif .sessionFailed then "failed" else "other" end),
            text: (.messageContent.text // .progressUpdated.title // .progressUpdated.description // .userMessaged.userMessage // .planGenerated.plan.steps[0].title // "")[:400]
        }'
}

get_artifacts() {
  local session_id="$1"
  echo "🔍 Fetching artifacts (diffs, bash output) for session $session_id..."

  curl "${curl_opts[@]}" "$API_BASE/sessions/$session_id/activities?pageSize=50" \
    | jq '[.activities[] | select(.artifacts != null) | .artifacts[]] | {
            changeSets: [.[] | select(.changeSet != null) | {
                source: .changeSet.source,
                baseCommit: .changeSet.gitPatch.baseCommitId,
                commitMessage: .changeSet.gitPatch.suggestedCommitMessage,
                diff: .changeSet.gitPatch.unidiffPatch
            }],
            bashOutputs: [.[] | select(.bashOutput != null) | {
                command: .bashOutput.command,
                exitCode: .bashOutput.exitCode,
                output: .bashOutput.output[:500]
            }],
            media: [.[] | select(.media != null) | {
                mimeType: .media.mimeType
            }]
        }'
}

# ============================================================================
# SOURCE ACTIONS
# ============================================================================

list_sources() {
  local count="${1:-10}"
  curl "${curl_opts[@]}" "$API_BASE/sources?pageSize=$count" \
    | jq '.sources[] | {
            name,
            displayName,
            repo: .gitHubRepo.fullName,
            defaultBranch: .gitHubRepo.defaultBranch
        }'
}

get_source() {
  local source_id="$1"
  curl "${curl_opts[@]}" "$API_BASE/$source_id" | jq '.'
}

# ============================================================================
# MAIN DISPATCH
# ============================================================================

case "${1:-}" in
  # Session Actions
  create-session)
    [[ -z "${2:-}" || -z "${3:-}" ]] && {
      echo "Error: source and prompt required" >&2
      usage
      exit 1
    }
    create_session "$2" "$3" "${4:-}"
    ;;
  get-session)
    [[ -z "${2:-}" ]] && {
      echo "Error: session_id required" >&2
      usage
      exit 1
    }
    get_session "$2"
    ;;
  delete-session)
    [[ -z "${2:-}" ]] && {
      echo "Error: session_id required" >&2
      usage
      exit 1
    }
    delete_session "$2"
    ;;
  list-sessions)
    list_sessions "${2:-10}"
    ;;
  send-message)
    [[ -z "${2:-}" || -z "${3:-}" ]] && {
      echo "Error: session_id and message required" >&2
      usage
      exit 1
    }
    send_message "$2" "$3"
    ;;
  approve-plan)
    [[ -z "${2:-}" ]] && {
      echo "Error: session_id required" >&2
      usage
      exit 1
    }
    approve_plan "$2"
    ;;

  # Activity Actions
  get-activities)
    [[ -z "${2:-}" ]] && {
      echo "Error: session_id required" >&2
      usage
      exit 1
    }
    get_activities "$2" "${3:-5}"
    ;;
  get-artifacts)
    [[ -z "${2:-}" ]] && {
      echo "Error: session_id required" >&2
      usage
      exit 1
    }
    get_artifacts "$2"
    ;;

  # Source Actions
  list-sources)
    list_sources "${2:-10}"
    ;;
  get-source)
    [[ -z "${2:-}" ]] && {
      echo "Error: source_id required" >&2
      usage
      exit 1
    }
    get_source "$2"
    ;;

  # Help
  -h | --help | help)
    usage
    ;;
  *)
    echo "Error: Unknown action '${1:-}'" >&2
    usage
    exit 1
    ;;
esac
