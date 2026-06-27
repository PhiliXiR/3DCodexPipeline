# MMO Camera System

This folder contains the reusable MMO-style third-person camera foundation.

The camera system is implemented in slices and must remain reusable infrastructure. It should not introduce player movement, gameplay, theme, levels, or game-specific assumptions.

Primary references:

- `docs/runtime_systems/mmo_camera_system_contract.md`
- `docs/adr/0003-mmo-camera-system-architecture.md`
- `skills/godot-mmo-camera/SKILL.md`

## Planned Components

- Camera settings resource.
- Camera controller.
- Orbit controller.
- Zoom controller.
- Collision handler.
- Mode output adapter.

## Current Slice

The current implementation includes:

- `MMOCameraSettings` resource.
- `MMOCameraController` script.
- `MMOCameraRig.tscn` reusable camera scene.
- `MMOCameraOrbitTest.tscn` neutral validation scene.
- `validate_mmo_camera_orbit_slice.gd` headless Godot validation.
- `validate_mmo_camera_zoom_slice.gd` headless Godot zoom validation.

This slice proves target following, code-driven orbit, right-mouse mouse-look, and smooth mouse-wheel zoom against a generic target proxy. Collision and mode output are intentionally handled by later issue slices.

## Validation

Run the neutral orbit validation:

```powershell
python tools/godot/run_mmo_camera_orbit_validation.py
```

Run the mouse-look validation:

```powershell
python tools/godot/run_mmo_camera_mouse_look_validation.py
```

Run the zoom validation:

```powershell
python tools/godot/run_mmo_camera_zoom_validation.py
```

## Future Extension Seams

- Target lock.
- Camera shake.
- Camera zones.
