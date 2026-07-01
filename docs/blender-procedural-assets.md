# Blender Procedural Assets

3DCodexPipeline owns reusable generators. Games own the generated outputs that
are selected for review or use.

## Modular Dock Generator

The first generator creates a modular wooden dock section from Blender
primitives and exports `.blend`, `.glb`, a preview `.png`, and JSON metadata.

Example:

```powershell
& "C:\Program Files (x86)\Steam\steamapps\common\Blender\blender.exe" --background --python tools/blender/generators/modular_dock_generator.py -- `
  --output-dir C:\_Dev\OneMoreCast\assets\_review\generated\issue-44-procedural-dock `
  --name dock_straight_01 `
  --length 8 `
  --width 2.5 `
  --plank-count 12 `
  --post-count 4 `
  --seed 7
```

The generator does not hard-code game paths. Pass a destination directory from
the consuming game or from a temporary export area.
