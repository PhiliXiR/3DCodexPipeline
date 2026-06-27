# Folder Structure

This document explains the major folders in the repository. Keep it updated whenever the structure changes.

## Root

### `AGENTS.md`

Instructions for future AI agents working in this repository.

### `docs/`

Project documentation covering vision, architecture, coding standards, roadmap, and folder responsibilities.

### `game/`

The Godot project root. It contains runtime code, scenes, data, UI, assets, autoloads, and project configuration.

### `tools/`

Automation and development tooling outside the runtime game project.

### `tests/`

Automated tests, validation fixtures, and future regression checks.

### `skills/`

Future AI workflow guidance, specialized agent instructions, or reusable task procedures.

## `game/`

### `game/assets/`

Imported or processed art assets used by Godot. Synty-style assets and GLB outputs will eventually land here after the import pipeline processes them.

### `game/characters/`

Reusable character-related scenes and scripts. This folder remains empty until generic character foundations are approved.

### `game/world/`

Reusable world-building scenes, environment modules, navigation helpers, and spatial composition tools. This must remain genre-neutral.

### `game/ui/`

Reusable UI scenes, controls, themes, and presentation helpers.

### `game/systems/`

Reusable runtime systems such as input, interaction, inventory, dialogue, quests, saves, audio, settings, cameras, and other framework-level features.

### `game/data/`

Data resources and configuration files used by reusable systems.

### `game/scenes/`

Shared scenes, test scenes, and future project entry scenes. No gameplay scenes should be added during the foundation phase.

### `game/autoload/`

Scripts intended for Godot autoload registration. Use sparingly and only for stable global services.

## `tools/`

### `tools/blender/`

Blender automation scripts for future Synty asset processing, transform normalization, object naming, collision generation, GLB export, and import reports.

### `tools/godot/`

Godot command-line helper scripts and reusable project automation.

### `tools/editor/`

Godot editor plugins and editor-only workflows such as scatter tools, road generation, forest generation, interior population, and navigation helpers.

### `tools/importers/`

Asset import pipeline code that coordinates source assets, Blender processing, Godot import settings, and generated reports.

### `tools/validators/`

Validation scripts for assets, scenes, data files, import conventions, and project structure.
