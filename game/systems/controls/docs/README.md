# MMO Controls Feel System

This folder contains reusable input-feel coordination for MMO-style camera and movement behavior.

The controls feel system is foundation infrastructure. It should not own camera placement, character physics, animation, combat, UI, input rebinding persistence, or game-specific control schemes.

Primary references:

- `docs/runtime_systems/mmo_controls_feel_contract.md`
- `docs/adr/0005-mmo-controls-feel-layer.md`

## Current Slice

The current implementation includes:

- `MMOControlsMouseState` resource.
- `validate_mmo_controls_mouse_state_slice.gd` headless Godot validation.

This slice proves separate LMB state, separate RMB state, combined mouse-button state, camera orbit intent, camera-facing intent, and both-buttons forward movement intent.

## Integration Boundary

Camera systems may consume:

- `should_orbit_camera()`
- `is_left_mouse_look_active()`
- `is_right_mouse_look_active()`

Movement systems may consume:

- `should_face_camera_direction()`
- `should_move_forward_from_mouse()`

The controls feel system exposes intent only. Camera and movement systems remain responsible for applying their own transforms, smoothing, collision, velocity, and validation.

## Validation

Run the mouse state validation:

```powershell
python tools/godot/run_mmo_controls_mouse_state_validation.py
```
