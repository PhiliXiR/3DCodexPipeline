# MMO Controls Feel System

This folder contains reusable input-feel coordination for MMO-style camera and movement behavior.

The controls feel system is foundation infrastructure. It should not own camera placement, character physics, animation, combat, UI, input rebinding persistence, or game-specific control schemes.

Primary references:

- `docs/runtime_systems/mmo_controls_feel_contract.md`
- `docs/adr/0005-mmo-controls-feel-layer.md`

## Current Slice

The current implementation includes:

- `MMOControlsMouseState` resource.
- `MMOControlsCursorPolicy` resource.
- `validate_mmo_controls_mouse_state_slice.gd` headless Godot validation.
- `validate_mmo_controls_cursor_policy_slice.gd` headless Godot validation.

This slice proves separate LMB state, separate RMB state, combined mouse-button state, camera orbit intent, camera-facing intent, both-buttons forward movement intent, cursor capture during mouse look, cursor restoration when mouse look ends, and a disabled policy path for future UI overrides.

## Integration Boundary

Camera systems may consume:

- `should_orbit_camera()`
- `is_left_mouse_look_active()`
- `is_right_mouse_look_active()`

Movement systems may consume:

- `should_face_camera_direction()`
- `should_move_forward_from_mouse()`

The controls feel system exposes intent only. Camera and movement systems remain responsible for applying their own transforms, smoothing, collision, velocity, and validation.

## Manual Cursor Expectations

In playable validation scenes:

- Pressing and holding LMB or RMB should capture the cursor for mouse-look.
- Releasing the final held mouse-look button should restore the previous mouse mode.
- Holding both mouse buttons should keep mouse-look active and expose forward movement intent.
- Releasing one of two held mouse buttons should keep mouse-look active while the other remains held.
- Releasing both buttons should not leave the cursor captured.
- Future UI flows may override this by disabling or replacing the cursor policy resource.

## Validation

Run the mouse state validation:

```powershell
python tools/godot/run_mmo_controls_mouse_state_validation.py
```

Run the cursor policy validation:

```powershell
python tools/godot/run_mmo_controls_cursor_policy_validation.py
```
