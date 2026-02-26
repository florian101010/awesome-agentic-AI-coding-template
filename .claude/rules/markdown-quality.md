---
paths:
  - "**/*.md"
---

# Markdown Quality Rules

## Table Style

Use simplified `| --- | --- |` separator (no colons, no extra dashes). Ensures automatic alignment across all viewers and satisfies markdownlint MD060.

```markdown
| Column A | Column B |
| --- | --- |
| value | value |
```

## Fenced Code Blocks

Every fenced code block MUST include a language specifier: `js`, `html`, `css`, `text`, `markdown`, `json`, `bash`, etc. (markdownlint MD040)

## Headings

- Single H1 per file (MD025)
- Logical increments only — no skipping from H2 to H4 (MD001)
- All subheadings unique within the document (MD024)
- CHANGELOG exception: append version in parentheses to avoid MD024 (e.g., `### Geändert (v0.3.11)`)

## Links and Paths

- Use relative paths — no leading `/` or `./`
- Keep link targets consistent with actual file locations
