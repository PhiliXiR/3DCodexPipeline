# Coding Standards

These standards apply to future Godot 4 and GDScript work in this repository.

## Language

- Use typed GDScript.
- Prefer explicit parameter and return types.
- Prefer explicit variable types when inference is unclear.
- Avoid dynamic typing unless it materially improves interoperability with Godot APIs.

## File And Folder Naming

- Folders: `snake_case`.
- GDScript files: `snake_case.gd`.
- Scene files: `PascalCase.tscn` for reusable scene classes.
- Resource files: descriptive `snake_case` names.
- Test files: name after the unit or behavior under test.

## GDScript Naming

- Classes: `PascalCase`.
- Functions: `snake_case`.
- Variables: `snake_case`.
- Constants: `UPPER_SNAKE_CASE`.
- Signals: event-style `snake_case`.
- Private helpers: prefix with `_`.

## Script Size And Responsibility

- Prefer scripts in the 100-300 line range.
- Split files when responsibilities diverge.
- Avoid large manager classes.
- Use composition before inheritance.
- Keep tool scripts and runtime scripts clearly separated.

## Comments

Comments should explain why something exists, not restate what the code says.

Good comments include:

- Architectural constraints.
- Non-obvious Godot lifecycle behavior.
- Pipeline assumptions.
- Warnings about editor-only behavior.

Avoid comments that simply narrate straightforward assignments or function calls.

## Signals

- Use signals to decouple systems.
- Name signals after events that already happened or are being requested.
- Keep signal payloads typed and minimal.
- Document signal contracts when they cross system boundaries.

## Composition

Prefer reusable child nodes, components, resources, and signals over deep inheritance trees.

Inheritance is acceptable when there is a stable "is-a" relationship and shared behavior is unlikely to vary by composition.

## Scene Organization

- Keep scenes focused and reusable.
- Avoid hardcoded absolute node paths.
- Use exported references or setup methods for required dependencies.
- Keep visual structure, behavior, and data responsibilities clear.
- Do not create gameplay scenes during the foundation phase.

## Data Organization

- Prefer Godot `Resource` classes for editor-friendly configuration.
- Use external data files when bulk editing or pipeline tooling benefits from them.
- Keep data schemas documented.
- Validate data before relying on it at runtime.

## Testing Expectations

Tests should be added when systems have logic that can regress.

Future tests may include:

- Unit tests for pure GDScript logic.
- Scene validation tests.
- Asset import validation.
- Data schema validation.
- Tool regression tests.

Tests should be easy to run from automation and should not depend on game-specific content unless explicitly scoped to a future game.
