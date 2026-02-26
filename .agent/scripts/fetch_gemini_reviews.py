import subprocess
import json
import sys
import argparse
import concurrent.futures
import os

def parse_args():
    parser = argparse.ArgumentParser(description="Fetch and display Gemini Code Assistant comments for PRs.")
    parser.add_argument("prs", metavar="N", type=int, nargs="*", help="List of PR numbers to analyze.")
    parser.add_argument("--output-dir", default=".agent/tmp", help="Directory to save individual PR reports.")
    return parser.parse_args()

def get_repo_info():
    try:
        cmd = ["gh", "repo", "view", "--json", "owner,name"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True, timeout=10)
        data = json.loads(result.stdout)
        return f"{data['owner']['login']}/{data['name']}"
    except Exception:
        return None

def get_pr_data_comprehensive(pr_id, repo_full_name):
    # 1. Fetch Basic Data (Issue Comments + Reviews + Metadata)
    try:
        cmd = ["gh", "pr", "view", str(pr_id), "--json", "comments,reviews,title,url,number,headRefName,baseRefName"]
        result = subprocess.run(cmd, capture_output=True, text=True, check=True, timeout=10)
        pr_data = json.loads(result.stdout)
    except Exception as e:
        return {"id": pr_id, "error": str(e)}

    # 2. Fetch Inline Review Comments via API (Pulls all comments for the PR)
    try:
        # endpoint: GET /repos/{owner}/{repo}/pulls/{pull_number}/comments
        api_cmd = ["gh", "api", f"/repos/{repo_full_name}/pulls/{pr_id}/comments"]
        api_result = subprocess.run(api_cmd, capture_output=True, text=True, check=True, timeout=10)
        review_comments = json.loads(api_result.stdout)
        pr_data["reviewComments"] = review_comments
    except Exception:
        pr_data["reviewComments"] = [] # fallback

    return pr_data

def extract_gemini_insights(pr_data):
    if "error" in pr_data:
        return f"❌ PR #{pr_data.get('id','?')}: Error fetching data - {pr_data['error']}"

    pr_number = pr_data.get("number", pr_data.get("id", "Unknown"))
    title = pr_data.get("title", "No Title")
    url = pr_data.get("url", "")

    # Combine all interaction types
    all_interactions = []

    # Label them for context
    # Issues comments (top level)
    for c in pr_data.get("comments", []):
        c["_type"] = "Comment"
        all_interactions.append(c)

    # Full review objects (verdicts/summaries)
    for r in pr_data.get("reviews", []):
        r["_type"] = "Review"
        all_interactions.append(r)

    # Inline review comments (diff-linked)
    for rc in pr_data.get("reviewComments", []):
        rc["_type"] = "Inline Code Comment"
        all_interactions.append(rc)

    # Sort by creation date
    all_interactions.sort(key=lambda x: x.get("createdAt", x.get("submittedAt", x.get("created_at", ""))))

    gemini_comments = []

    # Filter for Gemini bot comments
    for c in all_interactions:
        # PR view uses 'author', GH API uses 'user'
        author_obj = c.get("author", c.get("user", {}))
        author_raw = author_obj.get("login", "")
        author = author_raw.lower()
        body = c.get("body", "")

        # Robust pattern matching
        is_gemini = (
            author_raw == "gemini-code-assist[bot]" or
            "gemini" in author or
            "gemini" in body.lower() or
            "gstatic.com/codereviewagent" in body
        )

        if is_gemini:
            type_label = c.get("_type", "Comment")
            created_at = c.get("createdAt", c.get("submittedAt", c.get("created_at", "Unknown Time")))

            block = []
            block.append(f"   **[{type_label}]** {created_at}")

            # Inline comment extra details
            if type_label == "Inline Code Comment":
                path = c.get("path", "unknown file")
                line = c.get("line", c.get("original_line", "?"))
                block.append(f"   *File: {path}:{line}*")

                diff_hunk = c.get("diff_hunk", "")
                if diff_hunk:
                    diff_indented = "\n".join([f"   | {l}" for l in diff_hunk.splitlines()])
                    block.append("   *Target Code Context:*")
                    block.append(diff_indented)
                    block.append("")

            # Body content
            if body:
                block.append("   *Gemini Suggestion:*")
                body_indented = "\n".join([f"   > {l}" for l in body.splitlines()])
                block.append(body_indented)
            else:
                 block.append("   > [Empty Body]")

            block.append("") # Spacer

            gemini_comments.append("\n".join(block))

    output = []
    output.append(f"🔍 **PR #{pr_number}: {title}**")
    output.append(f"   Link: {url}")

    if gemini_comments:
        output.append("\n   🤖 **Gemini Analysis (Full Content):**\n")
        output.extend(gemini_comments)
    else:
        output.append("   ⚪ No Gemini comments found.")

    return "\n".join(output)

if __name__ == "__main__":
    args = parse_args()

    repo_full_name = get_repo_info()
    if not repo_full_name:
        sys.exit(1)

    target_prs = args.prs
    if not target_prs:
        print("Usage: fetch_gemini_reviews.py <PR_NUMBERS...>")
        sys.exit(0)

    os.makedirs(args.output_dir, exist_ok=True)

    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        future_to_pr = {executor.submit(get_pr_data_comprehensive, pr_id, repo_full_name): pr_id for pr_id in target_prs}
        results = []
        for future in concurrent.futures.as_completed(future_to_pr):
            data = future.result()
            if "number" not in data and "id" in data:
                 data["number"] = data["id"]
            results.append(data)

    results.sort(key=lambda x: x.get("number", 0))

    final_report = []
    for r in results:
        report_segment = extract_gemini_insights(r)
        
        # Output to individual file
        pr_id = r.get("number", "unknown")
        with open(os.path.join(args.output_dir, f"pr_{pr_id}_gemini_report.md"), "w") as f:
            f.write(f"# Gemini Insights for PR #{pr_id}\n\n")
            f.write(report_segment)
            
        print(report_segment)
        final_report.append(report_segment)

    # Master report
    with open(os.path.join(args.output_dir, "gemini_insights_report.md"), "w") as f:
        f.write("# Gemini Code Assist - PR Insights Report (Full Content)\n\n")
        f.write("\n---\n".join(final_report))
