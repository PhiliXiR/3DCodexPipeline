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

## Character Integration Boundary

The camera exposes read-only direction and mode data for future character systems. It must not rotate a character, read movement input, choose animations, or own physics movement.

Mode semantics:

- MMO mode: future character systems rotate toward movement direction while the camera orbits independently.
- Action mode: future character systems may rotate toward camera planar forward.

Current public direction helpers:

- `get_camera_forward()`
- `get_camera_planar_forward()`
- `get_camera_planar_right()`
- `is_mouse_look_active()`

## Current Slice

The current implementation includes:

- `MMOCameraSettings` resource.
- `MMOCameraExtensionHooks` passive extension hook resource.
- `MMOCameraModeOutput` read-only output resource.
- `MMOCameraController` script.
- `MMOCameraRig.tscn` reusable camera scene.
- `MMOCameraOrbitTest.tscn` neutral validation scene.
- `validate_mmo_camera_orbit_slice.gd` headless Godot validation.
- `validate_mmo_camera_zoom_slice.gd` headless Godot zoom validation.
- `validate_mmo_camera_collision_slice.gd` headless Godot collision validation.
- `validate_mmo_camera_mode_output_slice.gd` headless Godot mode output validation.
- `validate_mmo_camera_extension_hooks_slice.gd` headless Godot extension hook validation.

This slice proves target following, code-driven orbit, right-mouse mouse-look, smooth mouse-wheel zoom, camera collision, camera mode output, and passive future extension hooks against a generic target proxy.

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

Run the collision validation:

```powershell
python tools/godot/run_mmo_camera_collision_validation.py
```

Run the mode output validation:

```powershell
python tools/godot/run_mmo_camera_mode_output_validation.py
```

Run the extension hooks validation:

```powershell
python tools/godot/run_mmo_camera_extension_hooks_validation.py
```

## Future Extension Seams

- Target lock: provider hook only; no target selection, framing, or tracking behavior yet.
- Camera shake: provider hook only; no additive offsets, decay, or shake events yet.
- Camera zones: provider hook only; no trigger volumes, setting overrides, or transition rules yet.
