# Architecture

The project is organized as a reusable Godot 4 development foundation. Its architecture favors modular systems, data-driven configuration, editor tooling, and automated asset processing.

## High-Level Areas

- `game/`: Godot project files, scenes, reusable runtime systems, data, UI, and imported assets.
- `tools/`: External automation, Blender scripts, Godot helper scripts, importers, validators, and editor tooling.
- `docs/`: Human and AI-readable project guidance.
- `tests/`: Automated tests and validation fixtures.
- `skills/`: Future AI workflow instructions or task-specific agent guidance.

## Scene Philosophy

Scenes should be small, reusable, and composable.

- Prefer focused scenes that represent one reusable concept.
- Keep scene scripts responsible for the behavior of their owning node.
- Avoid deep scene trees that depend on fragile absolute paths.
- Use exported `NodePath`, typed references, resources, groups, and signals where appropriate.
- Keep prototype or game-specific scenes separate from reusable foundation scenes once gameplay begins.

## Dependency Direction

Dependencies should generally move from specific features toward generic services, never the other way around.

Runtime systems should not depend on future game themes or content. For example, an inventory framework may know about item data resources, but it must not know about a specific genre, item list, or story concept.

Recommended dependency direction:

1. Generic utilities and data definitions.
2. Runtime systems.
3. UI presentation.
4. Game-specific features.
5. Game-specific content.

Lower-level folders should not import or directly reference higher-level folders.

## Runtime Systems

Future reusable systems belong under `game/systems/`. Examples may include input, interaction, inventory, dialogue, quests, save data, audio, UI framework, settings, weather, time of day, NPC behavior, and camera control.

These systems should be added only when needed and approved. Initial architecture should make room for them without implementing them prematurely.

## Data-Driven Design

Reusable systems should prefer data definitions over hardcoded behavior.

Godot `Resource` classes are the preferred home for reusable data definitions when they need editor support. External files such as JSON or CSV may be used when they make pipeline automation or bulk editing easier.

## Tooling Architecture

Tooling is first-class in this project.

- Blender automation belongs in `tools/blender/`.
- Godot helper scripts belong in `tools/godot/`.
- Godot editor plugins and editor-specific workflows belong in `tools/editor/`.
- Import pipeline code belongs in `tools/importers/`.
- Validation tools belong in `tools/validators/`.

Tools should produce clear logs or reports and should be safe to run repeatedly.

## Autoload Policy

Autoloads are allowed only for stable, genuinely global services. They should expose small APIs and avoid becoming broad manager objects.

Potential future autoloads might include logging, settings, save coordination, or service registries, but they should be introduced only when there is a concrete need.
