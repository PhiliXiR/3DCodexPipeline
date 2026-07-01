# MMO Camera System

This folder contains the reusable MMO-style third-person camera foundation.

The camera system is implemented in slices and must remain reusable infrastructure. It should not introduce player movement, gameplay, theme, levels, or game-specific assumptions.

Primary references:

- `docs/runtime_systems/mmo_camera_system_contract.md`
- `docs/runtime_systems/mmo_controls_feel_contract.md`
- `docs/adr/0003-mmo-camera-system-architecture.md`
- `docs/adr/0005-mmo-controls-feel-layer.md`
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

The MMO Controls Feel Layer may decide when mouse-look, camera-facing intent, both-buttons movement, cursor capture, or A/D behavior are active. The camera consumes look intent and exposes camera output; it does not own movement semantics.

The current camera rig applies the controls cursor policy while mouse-look is active. Future UI flows may replace or disable that policy without changing orbit, zoom, or collision behavior.

Mode semantics:

- MMO mode: character systems rotate toward movement direction while the camera orbits independently. RMB-held mouse look may expose camera-facing intent through mode output.
- Action mode: future character systems may rotate toward camera planar forward.

Current public direction helpers:

- `get_camera_forward()`
- `get_camera_planar_forward()`
- `get_camera_planar_right()`
- `is_mouse_look_active()`
- `should_face_camera_direction()`

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

This slice proves target following, code-driven orbit, right-mouse mouse-look, smooth mouse-wheel zoom, camera collision, camera mode output, RMB camera-facing intent, and passive future extension hooks against a generic target proxy.

## Default Feel Preset

`default_mmo_camera_settings.tres` is tuned as a neutral MMO-style playground preset:

- `default_distance = 7.0`, with `min_distance = 2.5` and `max_distance = 14.0`.
- `rotation_sensitivity = 0.12` for steadier long-session mouse look.
- `zoom_speed = 0.75` for smaller mouse-wheel distance steps.
- `follow_smoothing = 14.0`, `rotation_smoothing = 22.0`, and `collision_recovery_smoothing = 20.0` for responsive but damped camera movement.
- `collision_buffer = 0.35` to reduce near-surface clipping in the playground.

Future games should override this resource or provide their own preset rather than hard-coding feel changes in the controller.

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
