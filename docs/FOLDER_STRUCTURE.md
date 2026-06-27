# Folder Structure

This document explains the major folders in the repository. Keep it updated whenever folders are added, removed, renamed, or repurposed.

## Root

### `AGENTS.md`

AI collaboration guide. Future agents should read this before making changes.

### `.gitignore`

Git ignore rules for Godot-generated files, local editor noise, logs, reports, and Blender backup files.

### `docs/`

Project documentation. This is part of the architecture, not auxiliary material.

Important files:

- `PROJECT_VISION.md`: purpose, boundaries, and collaboration model.
- `ARCHITECTURE.md`: system boundaries, dependency direction, and architectural policies.
- `ASSET_PIPELINE.md`: source, generated output, import report, and pipeline smoke test conventions.
- `FOLDER_STRUCTURE.md`: repository layout and folder responsibilities.
- `CODING_STANDARDS.md`: GDScript, scene, naming, testing, and documentation conventions.
- `ROADMAP.md`: staged foundation roadmap.
- `GLOSSARY.md`: shared vocabulary.
- `PRD_AI_FIRST_GAME_FOUNDATION.md`: product and engineering requirements for the foundation.

Important folders:

- `docs/adr/`: Architecture Decision Records.

### `game/`

Godot project root. Runtime project files live here. Keep this folder free of external automation scripts unless they are part of the Godot project itself.

### `tools/`

Development automation outside runtime gameplay. Blender scripts, Godot helpers, editor tools, importers, and validators belong here.

### `tests/`

Automated tests, validation fixtures, and regression checks. This folder is intentionally separate from runtime systems so testing infrastructure does not become game content.

### `skills/`

Future project-specific AI workflow instructions. Use this only when a repeatable AI procedure is valuable enough to document separately from `AGENTS.md`.

## `game/`

### `game/project.godot`

Minimal Godot 4 project shell for the foundation.

### `game/README.md`

Local explanation of the Godot project root.

### `game/assets/`

Imported or processed assets used by Godot. Future GLB outputs and processed Synty-style assets may land here after the asset pipeline exists.

Do not place raw source asset dumps here without an import convention.

Generated pipeline outputs may be written under `game/assets/generated/`. These outputs are ignored by Git and should be recreated by pipeline scripts.

### `game/characters/`

Reusable character-related scenes and scripts. This folder is not approval to create a player, NPC, enemy, or themed character. It is reserved for future generic character foundations.

### `game/world/`

Reusable world-building scenes, spatial modules, navigation helpers, and environment composition tools. Keep this genre-neutral.

### `game/ui/`

Reusable UI scenes, controls, themes, and presentation helpers. Do not add game-specific HUDs or menus during the foundation phase.

### `game/systems/`

Reusable runtime systems. Future examples may include input, interaction, inventory, dialogue, quest framework, save system, audio, settings, camera, weather, day/night, or NPC framework.

Systems should be added only when approved and should remain data-driven and genre-neutral.

### `game/data/`

Reusable data definitions and configuration used by systems. Prefer documented schemas and validation.

### `game/scenes/`

Shared scenes, test scenes, and future entry scenes. During the foundation phase, avoid gameplay scenes and level content.

### `game/autoload/`

Scripts intended for Godot autoload registration. Use sparingly and only for stable global services.

## `tools/`

### `tools/README.md`

Overview of tooling responsibilities.

### `tools/blender/`

Blender automation scripts for future asset processing:

- Importing source asset packs.
- Normalizing transforms.
- Renaming objects.
- Generating collision meshes.
- Exporting GLB files.
- Generating processing reports.

Current scripts:

- `generate_pipeline_smoke_cube.py`: generates the Stage 1 neutral cube GLB and import report.

### `tools/godot/`

Godot command-line helper scripts and project automation.

Examples may eventually include import refresh commands, export checks, project metadata inspection, or headless validation.

### `tools/editor/`

Godot editor plugins and editor-only workflows.

Future examples may include scatter tools, road generation, forest generation, interior population, navigation helpers, scene validators, and import helpers.

### `tools/importers/`

Asset import pipeline coordination. Importers should connect source assets, Blender processing, Godot import settings, output placement, and reports.

Current scripts:

- `run_pipeline_smoke_test.py`: runs the Stage 1 Blender cube smoke test and validator.

### `tools/validators/`

Validation scripts for repository structure, documentation, assets, scenes, data files, naming conventions, and import outputs.

Current validators:

- `validate_project_structure.py`: checks the foundation folder and file contract.
- `validate_documentation_contract.py`: checks required documentation references and vocabulary.
- `validate_pipeline_smoke_cube.py`: checks the generated Stage 1 cube GLB and report contract.

## `tests/`

### `tests/README.md`

Testing guidance. Future tests should protect structure, tooling behavior, data schemas, scene contracts, and reusable system behavior.

## `skills/`

### `skills/README.md`

Reserved for future project-specific AI procedures.

Do not use this folder for gameplay design notes or theme ideas.
