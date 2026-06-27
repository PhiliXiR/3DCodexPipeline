# Architecture

The project is organized as a reusable Godot 4 development foundation. Its architecture favors modular systems, typed GDScript, data-driven configuration, editor tooling, automated asset processing, validation, and AI-readable documentation.

Architectural vocabulary is defined in `docs/GLOSSARY.md`. Durable technical decisions are recorded in `docs/adr/`.

## Architectural Goals

- Keep the foundation genre-neutral.
- Separate runtime code from development tooling.
- Make future asset processing repeatable.
- Keep reusable systems independent of future game-specific content.
- Prefer small composable modules over broad managers.
- Keep dependencies explicit and directional.
- Make project expectations verifiable through tests and validators.

## High-Level Areas

- `game/`: Godot project root, future runtime code, scenes, resources, UI, imported assets, and autoloads.
- `tools/`: External automation, Blender scripts, Godot helper scripts, editor tooling, importers, and validators.
- `docs/`: Human and AI-readable project guidance, ADRs, glossary, PRDs, and roadmap.
- `tests/`: Automated tests, fixtures, and regression checks.
- `skills/`: Future project-specific AI workflow instructions.

## Dependency Direction

Dependencies should generally flow from specific code toward generic services, not from generic foundation code toward specific game content.

Recommended conceptual direction:

1. Generic utilities and shared data definitions.
2. Reusable runtime systems.
3. Presentation and UI.
4. Game-specific features.
5. Game-specific content.

Lower-level foundation code must not reference higher-level game-specific content.

## Runtime Architecture

Future reusable runtime systems belong under `game/systems/`. Each system should have:

- A narrow responsibility.
- Typed public APIs.
- Clear data inputs.
- Minimal assumptions about other systems.
- Signals or explicit interfaces for integration.
- Documentation for its contract.
- Tests or validators when behavior can regress.

Potential future systems include input, interaction, inventory, dialogue, quests, save data, audio, UI framework, settings, weather, time of day, NPC behavior, and camera control. These are examples, not approval to implement them now.

Runtime system contracts are documented in `docs/runtime_systems/`. The first approved contract is the Settings System, recorded in ADR 0002. This is a contract only and does not add runtime implementation.

## Scene Philosophy

Scenes should be small, reusable, and composable.

Use scenes for reusable Godot node compositions. Avoid large scenes that hide many unrelated responsibilities.

Prefer:

- Focused scene roots.
- Typed scripts on owning nodes.
- Exported references for required collaborators.
- Signals for decoupled events.
- Resources for reusable configuration.

Avoid:

- Hardcoded absolute node paths.
- Deep scene trees that require fragile assumptions.
- Hidden editor-only setup without documentation.
- Game-specific scenes during the foundation phase.

## Data-Driven Design

Reusable systems should accept data definitions instead of embedding content.

Preferred data homes:

- Godot `Resource` classes for editor-friendly configuration.
- External files such as JSON or CSV when bulk editing, import pipelines, or external tools benefit from them.
- Generated reports for pipeline outputs.

Data schemas should be documented and validated before runtime systems rely on them.

## Tooling Architecture

Tooling is first-class.

- Blender automation belongs in `tools/blender/`.
- Godot command-line helpers belong in `tools/godot/`.
- Godot editor plugins and editor workflows belong in `tools/editor/`.
- Import pipeline coordination belongs in `tools/importers/`.
- Project, asset, scene, and data checks belong in `tools/validators/`.

Tools should be repeatable, safe to run more than once, and clear about what they changed. Tools should produce logs or reports when useful.

## Asset Pipeline Architecture

The future asset pipeline should support source assets moving through processing, validation, import, and reporting.

The first implemented pipeline test is documented in `docs/ASSET_PIPELINE.md`. It generates a neutral cube in Blender, exports GLB, writes an import report, and validates those outputs before any Godot import step is introduced.

Expected future responsibilities:

- Normalize transforms.
- Rename objects consistently.
- Generate collision meshes.
- Export GLB files.
- Apply Godot import conventions.
- Generate import reports.
- Validate processed assets.

The pipeline should not assume a game theme. Synty-style assets are an asset source and style constraint, not a creative direction.

## Autoload Policy

Autoloads are allowed only for stable global services with small APIs.

Use an autoload only when:

- The service is truly global.
- The API is stable and narrow.
- The system would become harder to understand if passed explicitly.
- The service does not become a dumping ground for unrelated responsibilities.

Avoid creating broad "manager" autoloads. Prefer explicit composition until a global service is clearly justified.

## Testing And Validation Architecture

Tests and validators should protect the foundation contract.

Initial priority:

- Validate required repository structure.
- Validate required documentation exists.
- Validate docs reference current folders and ADRs.

Later priorities:

- Validate asset import conventions.
- Validate scene structure.
- Validate data schemas.
- Test reusable runtime system behavior.
- Test tooling outputs and reports.

## Architecture Change Policy

Add or update an ADR when a change affects:

- Top-level structure.
- Dependency direction.
- Tooling strategy.
- Data schema strategy.
- Runtime system boundaries.
- Autoload policy.
- Testing strategy.

Architecture should evolve deliberately and stay documented.
