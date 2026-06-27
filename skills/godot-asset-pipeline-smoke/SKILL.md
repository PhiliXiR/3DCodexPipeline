---
name: godot-asset-pipeline-smoke
description: Use when extending or validating the repository's Blender-to-Godot generated cube asset pipeline smoke test.
---

# Godot Asset Pipeline Smoke

## when_to_use

Use this skill when working on the Stage 1 or Stage 2 asset pipeline smoke tests for this repository.

Good uses:

- Updating the Blender-generated cube smoke test.
- Updating the import report schema.
- Updating the Godot import/load validation.
- Diagnosing Blender or Godot pipeline smoke failures.
- Adding the next non-game asset pipeline validation stage.

Do not use this skill for:

- Building gameplay.
- Creating player, level, enemy, item, quest, or themed content.
- Importing real asset packs.
- Designing a final art direction.

## required_context

Before acting, read:

- `docs/ASSET_PIPELINE.md`
- `docs/ARCHITECTURE.md`
- `docs/FOLDER_STRUCTURE.md`
- `docs/CODING_STANDARDS.md`
- `AGENTS.md`
- `tools/blender/generate_pipeline_smoke_cube.py`
- `tools/importers/run_pipeline_smoke_test.py`
- `tools/importers/run_godot_pipeline_smoke_import.py`
- `tools/validators/validate_pipeline_smoke_cube.py`
- `tools/godot/validate_pipeline_smoke_cube_import.gd`

## workflow

1. Confirm whether the work targets Stage 1 Blender output validation, Stage 2 Godot import validation, or a new pipeline stage.
2. Keep the asset generated and theme-neutral.
3. Keep generated outputs under `game/assets/generated/`.
4. Keep generated outputs ignored by Git.
5. Update the import report schema only when the validator and docs are updated together.
6. Preserve command-line overrides for local tool paths, such as `--blender-path` and `--godot-path`.
7. Prefer clear hard failures over silent skips when required tools are missing.
8. Do not add gameplay scenes or game-specific assets.

## validation

Run the Stage 1 Blender output validation:

```powershell
python tools/importers/run_pipeline_smoke_test.py
```

If Blender is not on `PATH`, pass:

```powershell
python tools/importers/run_pipeline_smoke_test.py --blender-path "C:\Path\To\blender.exe"
```

Run the Stage 2 Godot import validation:

```powershell
python tools/importers/run_godot_pipeline_smoke_import.py
```

If Godot is not on `PATH`, pass:

```powershell
python tools/importers/run_godot_pipeline_smoke_import.py --godot-path "C:\Path\To\godot.exe"
```

Run foundation validators:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
```

Expected result:

- Blender generates `cube.glb` and `cube.import_report.json`.
- The import report matches schema version 1 unless intentionally updated.
- Godot loads the generated GLB as a `PackedScene`.
- Generated outputs remain ignored by Git.

## handoff_output

When finished, report:

- Which pipeline stage changed.
- Generated output paths.
- Whether Blender validation passed.
- Whether Godot import validation passed.
- Any tool path overrides used.
- Whether generated outputs remain ignored.
- Follow-up pipeline stages that should become new issues.

## promotion_notes

Before promoting this skill globally:

- Replace repository-specific paths with placeholders.
- Add guidance for projects with different Godot project roots.
- Add guidance for projects that commit generated fixtures.
- Confirm the workflow in a second Godot repository.
- Decide whether the generated cube remains the canonical first smoke asset.
