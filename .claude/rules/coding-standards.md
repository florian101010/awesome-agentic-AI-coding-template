# Coding Standards

<!-- SYNC: Keep in sync with .agent/rules/coding-standards.md and .kilocode/rules/coding-standards.md -->

Project-wide conventions not covered by path-scoped rules.

<!-- SETUP: Add cross-references to path-scoped rule files once created, e.g.:
> CSS rules → `css-rules.md` | Config patterns → `config-patterns.md`
-->

## Documentation & Comments

- Every config file MUST have a **JSDoc-style block comment at the top** — explain the schema, field types, required/optional fields, and any runtime behavior (e.g., fallback logic)
- Use `/* ... */` block comments for section headers and multi-line explanations
- Use `//` inline comments sparingly — only where intent is non-obvious
- Keep all code-level comments in **English**
- When adding a new config field: update the file-top comment to document it

## Encoding

- All files: **UTF-8 without BOM**
