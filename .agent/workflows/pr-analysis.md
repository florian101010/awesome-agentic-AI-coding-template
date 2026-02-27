---
description: A rigorous workflow for analyzing Pull Requests and ensuring adherence to project architecture and coding rules.
trigger: when a PR is opened or updated, or when the user says "Analyze PRs"
---

# PR Analysis Workflow

This workflow defines the standard operating procedure for auditing Pull Requests (PRs). It ensures that architectural constraints are maintained, no prohibited patterns are introduced, and all changes align with `AGENTS.md`.

**Non-Interactive Guarantee:** All checks must be performed non-interactively using MCP tools or read-only shell commands.

> **Trigger:** Run this workflow using `/pr-analysis` or say "Analyze PRs".
>
> [!IMPORTANT]
> **MANDATORY FIRST STEP:** Before starting the analysis, you MUST read all policies in `AGENTS.md` and `.agent/rules/`. These rules are "Always-On" and override any steps in this workflow.

## 0. Phase 0: Clean Start & Forensics

**Goal:** Ensure no stale data exists and fetch ground truth if available.

1. **Wipe Temporary Directory:**

   ```bash
   rm -rf .agent/tmp && mkdir -p .agent/tmp
   echo "Workspace cleaned."
   ```

2. **Jules Context & Forensics (Optional):**
   If the PR was created by Jules/Askida, fetch its execution logs to detect silent failures:
   - Identify Jules Task ID from the PR body (`jules.google.com/task/[ID]`)
   - Use `.agent/scripts/jules-api.sh get-session <ID>` > `.agent/tmp/jules_session.json`
   - Use `.agent/scripts/jules-api.sh get-activities <ID> 20` > `.agent/tmp/jules_activities.json`
   - Review logs for explicit `FAILED` or `error` states.

## 1. Triage & Hygiene Check

**Goal:** Determine if the PR is safe to analyze.

> [!TIP]
> **Tool Strategy:** Always prefer **GitHub MCP** tools over `gh` CLI when available.
> **Data Persistence Rule:** You MUST persist all diffs and triage results to `.agent/tmp/` files (e.g., `pr_<N>.diff`).

1. **List Open PRs & Identify Batch Conflicts:**
   Use the `mcp_github-mcp-server_list_pull_requests` tool to fetch open PRs.
   *Batch Strategy:* If multiple PRs are open, group them by affected files. Actively hunt for competing AI-generated PRs that attempt to introduce the same base infrastructure simultaneously. Choose ONE clear winner that is robust and secure, and REJECT the others to prevent overlapping merge conflicts.

2. **Check for "Dirty Branching" & Artifact Pollution:**
   Check the commit history of the PR. If you see > 10 commits or commits unrelated to the PR title, the branch is **contaminated**. Instruct a rebase.
   *Pollution Check:* Ensure no temporary agent files (`.patch`, `.diff`, contents from `.agent/tmp/`) are mistakenly included in the PR diff. If found, **REJECT**.

3. **Empty Diff Check (Superseded):**
   *Diff Check:* Ensure the PR actually contains a valid diff against the default branch. If the changes have already been merged out-of-band or superseded, **REJECT** the PR.

4. **Check for Merge Conflicts (Strict Blocker):**
   Use the `mcp_github-mcp-server_pull_request_read` tool (`method="get"`). Check the `mergeable` status.
   *Conflict Blocker:* If the PR has merge conflicts (e.g., `mergeable` is false or `mergeable_state` is `dirty`/`conflicting`), you **MUST NOT APPROVE** the PR under any circumstances. Draft a `REQUEST_CHANGES` or `COMMENT` review instructing the author to rebase and resolve conflicts first.

5. **Check Existing Review Status:**
   Fetch existing reviews. If already `APPROVED`, note this in the report.

## 2. Deep Code Audit (Iterative Loop)

**CRITICAL INSTRUCTION:** You must perform these steps for **EVERY SINGLE OPEN PR**, one by one.

### Execution Loop (For Each PR)

1. **Isolate & Fetch (Forensics):**
   - Run the automated forensics script (if available):

     ```bash
     .agent/scripts/analyze_pr.sh <PR_NUMBER>
     ```

   - This script generates `.agent/tmp/pr_<PR_NUMBER>.diff` and runs threat scans. If a Gemini AI review is configured, it outputs to `.agent/tmp/pr_<PR_NUMBER>_gemini_report.md`.

2. **The "Gemini" Second Opinion (if configured):**
   - Review the generated `.agent/tmp/pr_<PR_NUMBER>_gemini_report.md`.
   - Do the suggestions align with repository constraints?
   - If a fix is suggested, verify it manually before requesting changes.

3. **Architecture Constraint Check (CRITICAL Line-by-Line Verification):**
   <!-- SETUP: Customize these checks to match your project's constraints from AGENTS.md. -->
   - [FILL: Primary architecture constraint check — e.g. "Does the PR add runtime dependencies or framework imports? -> BLOCK & REJECT"]
   - [FILL: Secondary constraint — e.g. "Dev/test tooling in package.json is allowed if runtime constraints remain intact"]

4. **The CSS & Layout Check:**
   <!-- SETUP: Customize or remove these checks based on your project's UI conventions. -->
   - [FILL: CSS/layout rules — e.g. "Are interactive elements using proper touch/hover handling?"]
   - [FILL: Additional style rules — e.g. "Are :hover states properly guarded for touch devices?"]

5. **The Code Quality & Config Check:**
   <!-- SETUP: Customize these checks to match your project's coding patterns. -->
   - [FILL: Config pattern check — e.g. "Are config files following the required pattern?"]
   - [FILL: Prohibited API check — e.g. "Is any prohibited API being used? -> REJECT"]
   - Are relative paths correct (no leading `/` or `./`)?

6. **The UI / Copy Check:**
   - [FILL: Language/copy rules — e.g. "Does new copy follow the project's style guide?"]

7. **The Asset Check:**
   - [FILL: Asset conventions — e.g. "Do new assets follow the config conventions?"]
   - [FILL: Asset helper check — e.g. "Is the designated asset helper function used?"]

8. **Impact Analysis & Prioritization:**
   Document for each PR in your internal notes:
   - **Merge Priority:** (Bug Fixes > Enhancements > Refactors)
   - **What It Does:** Plain-language explanation
   - **Advantages / Disadvantages:** Trade-offs
   - **Feature Regressions:** Any affected functionality

## 3. Zero Drift Validation

**Goal:** Ensure consistency across the ecosystem.

1. **Check Documentation:**
   - If code/config changed, were the relevant docs updated?
   - Was `CHANGELOG.md` updated for user-facing changes?

## 4. Batch Review & Merge Strategy Summary

**Goal:** Provide the user with a high-level overview of all analyzed PRs and recommend an optimal merge order to prevent conflicts.

1. **Generate Merge Strategy Report:**
   - If you are auditing multiple PRs, create an artifact (e.g., `pr_batch_summary.md`) before asking for final approval.
   - For **every PR analyzed**, you MUST explicitly detail:
     - **Merge Priority & Optimal Sorting:** Recommend the exact order to merge (e.g., base infrastructure first, isolated tests second).
     - **What it does:** Plain-language explanation of the changes.
     - **Advantages / Disadvantages:** Trade-offs, architectural alignment, or potential regressions.
     - **Verdict:** Explicit recommendation to APPROVE & MERGE or CLOSE/REJECT (with reasoning).

## 5. Comment Drafting & Feedback Loop

**Goal:** Turn analysis into actionable, professional feedback via GitHub MCP.

1. **Draft Detailed Comments:**
   - Maintain a working document at `.agent/tmp/pr_analysis_comments.md`.
   - Base your decision (APPROVE / REQUEST_CHANGES / COMMENT) on the checks above.

2. **Review & Action Prompt:**
   - You MUST explicitly ask the user: "Do you want me to post the drafted comments summarizing my findings?" before posting.

3. **"Paranoid Mode" Deep Re-Verification (MANDATORY before APPROVAL)**
   Before posting an APPROVE review, complete this checklist in your draft:

   ```markdown
   ## Paranoid Mode Checklist - PR #<NUMBER>

   ### Git Hygiene & Conflicts
   - [ ] PR is explicitly `mergeable` right now? (No conflicts)
   - [ ] No temporary files or artifact pollution included?

   ### Architecture & Coding Rules
   - [ ] [FILL: Primary constraint verified? e.g. "No runtime dependencies added?"]
   - [ ] [FILL: Config pattern maintained?]
   - [ ] [FILL: Prohibited APIs not used?]

   ### UX & Presentation
   - [ ] [FILL: UI convention 1 verified?]
   - [ ] [FILL: UI convention 2 verified?]
   - [ ] [FILL: Copy/language rules followed?]

   ### Assets
   - [ ] [FILL: Asset paths correct?]
   - [ ] [FILL: Asset helper used correctly?]

   **VERDICT:** APPROVED / REJECT (reason)
   ```

4. **Post Comments (Mandatory Tools)**
   Do NOT use `gh pr review` via shell. Use `mcp_github-mcp-server_pull_request_review_write` or `mcp_github-mcp-server_add_issue_comment`.

   **Use these specific templates:**

   **Template 1: Code/Logic Change PRs**

   ```markdown
   ## Approved — Paranoid Mode Analysis Passed

   ### Verification Checklist
   **Architecture & Git Hygiene:**
   - [x] Architecture constraints verified
   - [x] Config integrity maintained
   - [x] PR is mergeable and free of conflicts

   **Quality & UX:**
   - [x] Code quality checks passed
   - [x] UI conventions followed

   **Evidence:**
   - Verified changes in `<file>` align with `AGENTS.md`.

   ---
   *Automated analysis by PR Analysis Workflow*
   ```

   **Template 2: UX/Copy/Cosmetic PRs**

   ```markdown
   ## Approved — UX Enhancement Verified

   ### Changes Verified
   - Visual/copy changes align with design guidelines

   ### Logic Unchanged
   - [x] Core behavior preserved

   ---
   *Automated analysis by PR Analysis Workflow*
   ```

## 6. Re-verification Loop

If the PR author updates the PR (or user says "Re-check"):

1. Fetch the fresh diff.
2. Re-run Phase 2 (Deep Code Audit).
3. Update your `.agent/tmp/` draft from `REQUEST_CHANGES` to `RE-VERIFIED` or `STILL FAILING`.
4. Notify the user of the new status.

## 7. Final Logistics & Metadata Sync

**CRITICAL RULE:** You are **FORBIDDEN** from merging PRs automatically. Wait for the user to explicitly say "Merge PR #X".

1. **Sync "Completed Date" (if configured):**
   Immediately after an approval, use the helper script:

   ```bash
   .agent/scripts/gh-helpers.sh set_project_completed_date <PR_NUMBER>
   ```

2. **Post-Merge Verification:**
   After the user merges, verify the local branch:

   ```bash
   git pull origin <default-branch>
   ```

   (Optional) If applicable, run through the `post-merge-analysis.md` workflow.
