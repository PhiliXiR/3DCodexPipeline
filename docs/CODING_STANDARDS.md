# Coding Standards

These standards apply to future Godot 4, GDScript, tooling, tests, and documentation work in this repository.

## General Rules

- Keep the foundation generic and reusable.
- Prefer clarity over cleverness.
- Prefer small focused files over large multi-purpose files.
- Avoid speculative systems.
- Update docs when conventions or architecture change.
- Add tests or validators when behavior can regress.

## Godot And GDScript

- Use Godot 4.x.
- Use typed GDScript.
- Prefer explicit parameter and return types.
- Prefer explicit variable types when inference is unclear.
- Avoid dynamic typing unless required by Godot APIs or tool integration.
- Avoid untyped dictionaries for long-lived contracts; prefer resources, typed objects, or documented schemas.

## File And Folder Naming

- Folders: `snake_case`.
- GDScript files: `snake_case.gd`.
- Tool scripts: `snake_case`, named by action and target.
- Scene files: `PascalCase.tscn` for reusable scene classes.
- Resource files: descriptive `snake_case` names.
- Test files: name after the behavior or contract under test.
- Documentation files: `UPPER_SNAKE_CASE.md` for major root docs, descriptive lowercase for ADR slugs.

## GDScript Naming

- Classes: `PascalCase`.
- Functions: `snake_case`.
- Variables: `snake_case`.
- Constants: `UPPER_SNAKE_CASE`.
- Signals: event-style `snake_case`.
- Private helpers: prefix with `_`.

Names should describe reusable responsibilities. Avoid theme-specific or game-specific names unless the project has explicitly moved into an approved game direction.

## Script Size And Responsibility

- Prefer scripts in the 100-300 line range.
- Split files when responsibilities diverge.
- One script should have one clear reason to change.
- Keep editor scripts separate from runtime scripts.
- Keep import pipeline logic separate from validation logic.
- Avoid large manager classes.

## Composition

Prefer composition through:

- Child nodes.
- Resources.
- Signals.
- Explicit setup methods.
- Small service objects.

Use inheritance when there is a stable, obvious relationship and shared behavior is unlikely to vary by composition.

## Signals

- Use signals to decouple systems.
- Name signals after meaningful events.
- Keep signal payloads typed and minimal.
- Avoid using signals as hidden control flow between distant systems.
- Document signal contracts when they cross system boundaries.

## Resources And Data

- Prefer Godot `Resource` classes for editor-friendly configuration.
- Use external data files when bulk editing, import tooling, or external generation benefits from them.
- Document data schemas.
- Validate data before runtime systems rely on it.
- Keep data generic until a game-specific direction is approved.

## Scenes

- Keep scenes focused and reusable.
- Avoid hardcoded absolute node paths.
- Use exported references, setup methods, groups, or signals for dependencies.
- Keep visual structure, behavior, and data responsibilities clear.
- Do not create gameplay scenes during the foundation phase.

## Autoloads

- Use autoloads sparingly.
- Autoload APIs should be small and stable.
- Do not create broad managers.
- Prefer explicit dependencies until global access is clearly justified.
- Document every autoload's responsibility and public API.

## Tooling

- Tool scripts should be repeatable.
- Tool scripts should fail clearly.
- Tool scripts should avoid silent mutation.
- Prefer reports for importers and validators.
- Keep Blender automation, Godot helpers, editor plugins, importers, and validators in their assigned folders.

## Comments

Comments should explain why something exists, not restate what the code says.

Good comments explain:

- Architectural constraints.
- Non-obvious Godot lifecycle behavior.
- Pipeline assumptions.
- Validation rules.
- Editor-only behavior.
- Compatibility notes.

Avoid comments that simply narrate assignments or function calls.

## Documentation

- Write docs in Markdown.
- Keep docs concise but complete enough for a new AI agent.
- Link related docs when a concept crosses files.
- Update `docs/GLOSSARY.md` when shared vocabulary changes.
- Add ADRs for durable decisions.

## Testing Expectations

Tests should verify externally visible behavior and project contracts, not private implementation details.

Initial testing targets:

- Required repository structure.
- Required documentation.
- ADR and glossary presence.

Future testing targets:

- Asset import validation.
- Data schema validation.
- Scene validation.
- Runtime system behavior.
- Tool regression tests.

Tests should be runnable from automation and should not require game-specific content unless scoped to an approved future game.
