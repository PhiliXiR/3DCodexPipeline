# Architecture Decision Records

Architecture Decision Records capture durable technical decisions for this foundation.

Use ADRs when a decision affects project structure, dependency direction, data shape, tooling strategy, testing strategy, or long-term maintainability.

## ADR Index

- [0000: ADR Template](0000-template.md)
- [0001: Establish AI-First Godot Foundation Structure](0001-ai-first-godot-foundation-structure.md)
- [0002: Use Settings As The First Runtime System Contract](0002-first-runtime-system-contract-settings.md)
- [0003: MMO Camera System Architecture](0003-mmo-camera-system-architecture.md)
- [0004: Character Movement System Architecture](0004-character-movement-system-architecture.md)

## When To Write An ADR

Write or update an ADR when a change affects:

- Top-level repository structure.
- Dependency direction.
- Runtime system boundaries.
- Tooling strategy.
- Data schema strategy.
- Autoload policy.
- Testing or validation strategy.
- Any durable convention future agents must follow.

Do not write ADRs for small implementation details, typo fixes, or narrow documentation edits that do not change project direction.

## Workflow

1. Copy `0000-template.md`.
2. Name the new file with the next four-digit number and a short lowercase slug.
3. Start with `Status: Proposed` unless the decision is already approved.
4. Link the ADR from this index.
5. Update related docs in the same change.
6. Add or update validators when the decision creates a checkable project contract.

## ADR Format

Each ADR should include:

- Status.
- Date.
- Context.
- Decision.
- Alternatives considered.
- Consequences.

Prefer short, concrete records. ADRs should explain why a decision was made, not duplicate every detail from implementation docs.
