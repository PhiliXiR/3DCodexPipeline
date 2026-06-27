# 0001: Establish AI-First Godot Foundation Structure

## Status

Accepted

## Date

2026-06-27

## Context

This repository is intended to become a reusable AI-assisted foundation for future 3D games built with Godot 4, typed GDScript, Synty-style assets, Blender-assisted processing, editor tooling, and modular runtime systems.

The project is not a game yet. It must avoid choosing a theme, genre, story, gameplay loop, player controller, level design direction, or concrete content. The first architectural need is a structure that makes future work easy for both humans and AI agents to understand and extend.

The foundation needs clear homes for:

- Godot project files and future runtime systems.
- Blender-assisted asset processing.
- Godot editor plugins and helper scripts.
- Importers and validators.
- Tests and documentation.
- Future AI workflow guidance.

## Decision

The repository will use a foundation-first structure with these top-level areas:

- `game/` for the Godot project root and future runtime project files.
- `tools/` for development automation outside runtime gameplay.
- `docs/` for project vision, architecture, standards, roadmap, glossary, PRDs, and ADRs.
- `tests/` for automated tests, validation fixtures, and regression checks.
- `skills/` for future project-specific AI workflow instructions.

The `game/` folder will contain generic runtime areas:

- `assets/`
- `characters/`
- `world/`
- `ui/`
- `systems/`
- `data/`
- `scenes/`
- `autoload/`

The `tools/` folder will separate tooling by responsibility:

- `blender/`
- `godot/`
- `editor/`
- `importers/`
- `validators/`

All folders must remain theme-neutral during the foundation phase. Empty folders may be preserved with placeholder files until concrete implementations exist.

## Alternatives Considered

### Put Everything Under `game/`

This would make the Godot project self-contained, but it would mix runtime code with external tooling, documentation, test fixtures, AI guidance, and pipeline scripts. That would make long-term repository navigation less clear.

### Keep Tools Inside Godot Addons Only

Godot editor plugins may eventually belong under an addons structure, but not all tooling is editor-only. Blender scripts, import orchestration, command-line validators, and reports need a broader tools area.

### Start With Gameplay Folders Only

Gameplay-first folders would encourage premature creative decisions and game-specific assumptions. This conflicts with the current goal of building a reusable foundation before choosing a game.

## Consequences

- Future agents have clear places to add docs, tools, tests, and runtime systems.
- Runtime project files stay separate from external automation.
- The structure is slightly larger than a minimal Godot project, but it reduces ambiguity for long-lived AI collaboration.
- The project can add gameplay later without rewriting the foundation layout.
- Documentation must be maintained alongside structural changes so folder purpose does not drift.
