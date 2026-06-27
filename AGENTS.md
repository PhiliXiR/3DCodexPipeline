# AI Agent Guide

This repository is an AI-first foundation for building future 3D games in Godot 4. It is not a game, and agents must not choose a genre, story, visual theme, or gameplay direction without explicit human approval.

The highest priority is to keep the project reusable, maintainable, simple, automatable, and easy for future AI agents to understand.

## Project Philosophy

- Build a professional game development foundation, not a single-game prototype.
- Keep systems generic until a specific future game is approved.
- Prefer small, composable modules over global managers.
- Use data-driven configuration wherever possible.
- Automate repetitive work through editor tools, importers, validators, and scripts.
- Document architectural intent near the systems that depend on it.

## Agent Responsibilities

AI agents may:

- Improve architecture and documentation.
- Create reusable Godot systems after approval.
- Add typed GDScript, tests, validators, and editor tooling.
- Create Blender and Godot automation scripts.
- Refactor toward clearer boundaries and stronger reuse.

AI agents must not:

- Invent lore, factions, characters, quests, worlds, or themes.
- Build gameplay before the approved foundation phase calls for it.
- Hardcode genre-specific assumptions.
- Add giant singleton managers as a first resort.
- Hide important behavior in undocumented editor state.
- Make broad architectural changes without explaining the reason and tradeoffs.

## Coding Rules

- Use Godot 4.x and typed GDScript.
- Prefer explicit types for variables, function parameters, and return values.
- Keep scripts small, usually 100-300 lines.
- One script should have one clear responsibility.
- Prefer composition through nodes, resources, and signals.
- Keep dependencies directional and easy to trace.
- Use comments only to explain intent, constraints, or non-obvious behavior.
- Avoid clever code when clear code would do.

## Naming Conventions

- Files and folders: `snake_case`.
- GDScript classes: `PascalCase`.
- Variables and functions: `snake_case`.
- Signals: past-tense or event-style `snake_case`, such as `interaction_started`.
- Constants: `UPPER_SNAKE_CASE`.
- Scenes: descriptive `PascalCase.tscn` when they represent reusable scene classes.
- Resources: descriptive names that include the resource role when useful.

## Preferred Patterns

- Small scene components with focused scripts.
- Resources for reusable configuration and data definitions.
- Signals for decoupled communication between peers.
- Autoloads only for truly global services with stable contracts.
- Editor plugins for repeatable workflows.
- Validators for asset, scene, and data quality checks.
- Import reports for automated asset pipeline work.

## Things To Avoid

- Theme-specific names in reusable systems.
- Direct references from low-level systems to high-level game features.
- Hidden dependencies on scene tree paths.
- Large inheritance hierarchies when composition is enough.
- One-off scripts that duplicate reusable tool behavior.
- Unvalidated asset import conventions.
- Silent failures in tools or import scripts.

## Proposing Changes

When proposing or making changes:

1. State the engineering goal.
2. Explain the files or systems affected.
3. Describe alternatives considered.
4. Call out tradeoffs and future migration concerns.
5. Update documentation when architectural intent changes.
6. Add or update tests and validators when behavior can regress.

## Documentation Expectations

- Update `docs/ARCHITECTURE.md` when module boundaries or dependency direction changes.
- Update `docs/FOLDER_STRUCTURE.md` when folders are added, removed, or repurposed.
- Update `docs/CODING_STANDARDS.md` when code conventions evolve.
- Update `docs/ROADMAP.md` when project phases change.
- Keep docs generic unless the human creative director approves a concrete game direction.

## Current Constraint

This repository is in the foundation phase. Do not create players, levels, enemies, items, quests, or game-specific assets.
