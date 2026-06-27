# Asset Pipeline

This document defines the first asset pipeline conventions for the AI-first Godot foundation. The pipeline remains theme-neutral and exists to prove repeatable asset processing before real game content is introduced.

## Stage 1: Blender Output Smoke Test

The first pipeline stage proves that Blender can generate a simple neutral asset, export it to a Godot-facing asset path, write a report, and validate the generated outputs.

Stage 1 does not require Godot import validation. Godot import is a later stage.

## Blender Requirement

Blender is a required dependency for the Stage 1 pipeline smoke test.

The runner discovers Blender in this order:

1. `--blender-path` command-line override.
2. `blender` on `PATH`.

Missing Blender is a hard failure with a clear diagnostic.

## Generated Output Location

Generated pipeline smoke outputs live under:

```text
game/assets/generated/pipeline_smoke/
```

This location proves that processed assets can land in the Godot-facing asset tree while remaining clearly marked as generated output.

Generated outputs are ignored by Git and should be recreated by running the pipeline.

## Pipeline Smoke Cube

The first smoke asset is a script-generated neutral cube.

Expected properties:

- Name: `pipeline_smoke_cube`
- Dimensions: `1m x 1m x 1m`
- Location: origin
- Rotation: zero
- Scale: one
- Output format: GLB

This cube is not game content. It is a deterministic asset pipeline fixture.

## Import Report Schema

The Stage 1 report is intentionally minimal and contract-focused.

```json
{
  "schema_version": 1,
  "pipeline": "pipeline_smoke_cube",
  "status": "success",
  "source": {
    "type": "generated",
    "generator": "tools/blender/generate_pipeline_smoke_cube.py"
  },
  "outputs": {
    "glb": "game/assets/generated/pipeline_smoke/cube.glb"
  },
  "asset": {
    "name": "pipeline_smoke_cube",
    "dimensions_meters": [1.0, 1.0, 1.0],
    "location": [0.0, 0.0, 0.0],
    "rotation_degrees": [0.0, 0.0, 0.0],
    "scale": [1.0, 1.0, 1.0]
  }
}
```

Future schema versions may add mesh count, material count, triangle count, collision status, source asset references, import settings, and Godot import validation.

## Commands

Run the Stage 1 pipeline smoke test from the repository root:

```powershell
python tools/importers/run_pipeline_smoke_test.py
```

If Blender is not on `PATH`, pass its executable explicitly:

```powershell
python tools/importers/run_pipeline_smoke_test.py --blender-path "C:\Path\To\blender.exe"
```

Validate existing generated outputs without rerunning Blender:

```powershell
python tools/validators/validate_pipeline_smoke_cube.py
```

## Stage 2: Future Godot Import Validation

The next stage should validate that Godot can import and load the generated GLB. That stage may use a headless Godot helper script and should not introduce gameplay, a player, a level, or a themed scene.
