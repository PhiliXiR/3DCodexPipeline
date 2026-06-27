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
```

The structure validator checks required folders, required docs, and the Godot project shell. The documentation validator checks that the core docs remain complete and discoverable.
