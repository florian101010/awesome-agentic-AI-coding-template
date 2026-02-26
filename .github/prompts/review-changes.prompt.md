---
name: 'review-changes'
description: 'Review current workspace changes for project rule compliance before committing'
agent: ask
---

Review the current changes in this workspace for compliance with the project rules.

Use `#changes` to see the current diff.

## Checks to Run

### Security
- All `innerHTML` with config-derived or runtime text goes through a safe escaping function
- No new `eval()`, `document.write()`, `postMessage`, `localStorage`, or `sessionStorage`

### Config Files
- IIFE + `Object.freeze` pattern maintained (if project uses IIFE config pattern)
- JSDoc top-comment updated if schema changed
- No new hardcoded data that belongs in config

### Paths
- No leading `/` or `./` in asset paths (if the project uses relative-only paths)

### API Contract
- Immutable IDs listed in `AGENTS.md` under "Immutable Contract" must not be changed

### [FILL: Project-specific check]
- [FILL: e.g. "touch-action: manipulation on every new interactive element"]

## Report Format

List each violation as:
- **File** + line reference
- **Rule violated** (exact rule text)
- **Snippet** (the offending code)
- **Fix** (one-line suggestion)

If no violations found, output: ✅ **Ready to commit.** — no rule violations detected.

