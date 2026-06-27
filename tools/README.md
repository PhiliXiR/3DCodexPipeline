# Tools

This folder contains automation and development tooling for the foundation.

- `blender/`: Blender-assisted asset processing.
- `godot/`: Godot command-line automation.
- `editor/`: Godot editor plugins and editor workflows.
- `importers/`: Import pipeline coordination.
- `validators/`: Project, asset, scene, and data validation.

## Foundation Validators

Run these from the repository root:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
python tools/validators/validate_repo_skills.py
```

The structure validator checks required folders, required docs, and the Godot project shell. The documentation validator checks that the core docs remain complete and discoverable. The repo skill validator checks that repo-local skills have the required shape.

## Asset Pipeline Smoke Test

Blender is required for the Stage 1 asset pipeline smoke test.

Run from the repository root:

```powershell
python tools/importers/run_pipeline_smoke_test.py
```

If Blender is not on `PATH`, pass:

```powershell
python tools/importers/run_pipeline_smoke_test.py --blender-path "C:\Path\To\blender.exe"
```

Generated outputs are written to `game/assets/generated/pipeline_smoke/` and ignored by Git.

Run the Stage 2 Godot import validation from the repository root:

```powershell
python tools/importers/run_godot_pipeline_smoke_import.py
```

If Godot is not on `PATH`, pass:

```powershell
python tools/importers/run_godot_pipeline_smoke_import.py --godot-path "C:\Path\To\godot.exe"
```
