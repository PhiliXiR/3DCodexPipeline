# Pipeline Smoke Contract Reference

The pipeline smoke test proves the generated asset contract, not gameplay or visual design.

Current contract:

- Blender is required for Stage 1.
- Godot is required for Stage 2.
- The cube is script-generated.
- The cube is neutral and `1m x 1m x 1m`.
- Generated outputs land under `game/assets/generated/pipeline_smoke/`.
- Generated outputs are ignored by Git.
- The import report uses schema version 1.
- Godot import validation loads the GLB as a `PackedScene`.
- No gameplay scene, player, level, or theme is introduced.
