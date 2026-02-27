# Architecture Decision Records (ADR)

This directory contains Architecture Decision Records for the project.

## What is an ADR?

An ADR captures a significant architectural decision along with its context, rationale, and consequences. ADRs provide a historical record of *why* decisions were made, not just *what* was decided.

## When to Create an ADR

Create a new ADR when:

- Changing the runtime baseline or target environment
- Modifying core rendering/state patterns
- Changing config architecture or global contracts
- Introducing new cross-cutting technical mechanisms
- Making any decision that would be hard or costly to reverse

## Template

Create a new file named `NNN-title-with-dashes.md` (e.g., `001-use-vanilla-js.md`):

```markdown
# ADR-NNN: Title

## Status

Proposed | Accepted | Deprecated | Superseded by [ADR-XXX](./XXX-title.md)

## Context

What is the issue that we're seeing that motivates this decision?

## Decision

What is the change that we're proposing and/or doing?

## Consequences

What becomes easier or harder as a result of this decision?

### Positive

- ...

### Negative

- ...

### Neutral

- ...

## Migration Notes

If applicable, what steps are needed to migrate existing code?
```

## Index

<!-- Add ADR entries here as they are created. -->

| ADR | Title | Status | Date |
| --- | --- | --- | --- |
| *None yet* | — | — | — |
