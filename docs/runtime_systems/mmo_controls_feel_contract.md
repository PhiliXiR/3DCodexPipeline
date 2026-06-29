# MMO Controls Feel Contract

## Status

Approved foundation contract. Implementation is split across the `MMO Controls` issue series.

## Purpose

The MMO Controls Feel layer coordinates camera and character movement input so the neutral playground feels closer to familiar long-session MMO controls, especially World of Warcraft and Final Fantasy XIV style expectations, without copying a specific game or introducing a theme.

This layer is an input-feel and coordination contract. It does not replace the MMO Camera System or Character Movement System.

## Responsibilities

The MMO Controls Feel layer is responsible for:

- Defining how left mouse button, right mouse button, both mouse buttons, WASD, and A/D behavior coordinate.
- Exposing mouse-button look state for camera and movement systems.
- Supporting LMB camera-only orbit.
- Supporting RMB camera look with character-facing intent.
- Supporting optional both-mouse-buttons move-forward intent.
- Supporting configurable A/D behavior for turn-left/turn-right versus strafe-left/strafe-right.
- Managing cursor capture and cursor visibility while mouse-look states are active.
- Providing data-driven default feel settings for the neutral playground.
- Providing validation guidance and manual checklists for MMO-style controls feel.

## Non-Goals

The MMO Controls Feel layer must not:

- Implement combat, targeting, tab targeting, action bars, abilities, interaction, UI, inventory, quests, or character classes.
- Choose a game theme, setting, faction, character fantasy, or final control scheme.
- Import or require Synty humanoid assets.
- Implement animation, root motion, or animation blending.
- Replace camera orbit/zoom/collision ownership.
- Replace character velocity, gravity, floor collision, or movement ownership.
- Implement input rebinding or settings persistence in the first controls-feel slices.

## Components

### Current Implementation Slice

The first implementation slices provide:

- `MMOControlsMouseState`, a reusable resource that tracks LMB, RMB, and both-buttons state and exposes derived camera orbit, character-facing, and mouse-forward intent.
- `MMOControlsCursorPolicy`, a reusable resource that captures the cursor while mouse-look is active and restores the previous mouse mode when mouse-look ends.

### Controls Feel Settings Resource

Defines tunable and configurable controls behavior.

Expected settings include:

- Enable or disable both-mouse-buttons move-forward.
- A/D behavior mode: turn or strafe.
- Cursor capture policy.
- Mouse look cursor visibility policy.
- RMB facing behavior policy.
- Optional sensitivity or tuning references when they coordinate camera and movement feel.

### Mouse Button State Model

Tracks mouse button state in a reusable form.

Expected states include:

- No mouse look.
- LMB-only look.
- RMB-only look.
- Both-buttons look.

The state model should expose derived intents:

- Camera orbit intent.
- Character-facing intent.
- Move-forward intent.
- Cursor capture intent.

### Camera Consumption

The MMO Camera System consumes the look state to decide when mouse motion should orbit the camera.

Expected camera behavior:

- LMB-only: camera orbits around the target without expressing character-facing intent.
- RMB-only: camera orbits and exposes character-facing intent for movement.
- Both buttons: camera orbits and exposes move-forward intent.

### Movement Consumption

The Character Movement System consumes movement input and controls-feel state to decide desired movement and facing.

Expected movement behavior:

- WASD remains the baseline movement input.
- RMB-held movement may align facing intent with camera planar forward.
- Both mouse buttons may produce forward movement intent when enabled.
- A/D behavior is configurable as turn or strafe.

### Cursor Policy

Mouse-look states may change Godot mouse mode and cursor visibility.

Expected policy:

- Enter a captured or confined mouse mode while active mouse-look is held.
- Restore the previous or configured mouse mode when mouse-look ends.
- Avoid stuck captured-cursor states when focus or input state changes.
- Keep the policy isolated so future UI systems can override it deliberately.

## Input Semantics

### Left Mouse Button

LMB-only behavior is camera-only orbit.

The camera may rotate around the target while the character's facing and movement direction remain controlled by movement input. LMB-only must not force character rotation.

### Right Mouse Button

RMB-only behavior is camera orbit plus character-facing intent.

The camera may rotate around the target. The controls-feel state should tell movement that camera-facing movement is desired while RMB is held. The movement system remains responsible for applying turn speed and final character rotation.

### Both Mouse Buttons

Both-buttons behavior may produce a move-forward intent.

This behavior should be configurable because not all future projects will want it. When enabled, both-buttons should act like forward movement using the same camera-relative basis as keyboard forward movement.

### W, A, S, D

Keyboard movement remains configurable through input action names.

Expected default:

- W: move forward relative to camera orientation.
- S: move backward relative to camera orientation.
- A/D: configurable as strafe or turn.

The current recommended foundation default is strafe, because the existing capsule movement slice already uses camera-relative strafe behavior and it is easier to validate without animation. Turn mode should be supported as a first-class option before final game tuning.

## Integration Boundaries

The controls-feel layer coordinates intent. It does not own camera transform math or movement physics.

Dependency direction:

```text
Input events
  -> MMO Controls Feel state
  -> Camera and Movement consume read-only intent
```

The camera system may consume look-state intent.

The movement system may consume movement/facing intent.

The controls-feel layer must not depend on game-specific content.

## Public API Shape

The future implementation should expose APIs equivalent to:

```text
set_controls_enabled(enabled)
get_mouse_button_state()
is_left_mouse_look_active()
is_right_mouse_look_active()
is_both_mouse_move_active()
should_orbit_camera()
should_face_camera_direction()
should_move_forward_from_mouse()
get_ad_behavior_mode()
```

The exact names may evolve during implementation, but the public surface should remain narrow and documented.

## Events

The system may emit typed signals equivalent to:

```text
mouse_button_state_changed(state)
cursor_capture_changed(is_captured)
ad_behavior_changed(mode)
```

Signals should notify consumers only. They must not hide movement or camera side effects.

## Test And Validation Expectations

Validation should cover:

- LMB-only look state.
- RMB-only look state.
- Both-buttons state.
- Cursor capture transitions.
- Cursor restoration after releasing the final mouse-look button.
- A/D mode selection.
- RMB-facing intent.
- Both-buttons forward intent.
- Existing camera and movement validations continuing to pass.
- Manual validation in the neutral playground.

## Documentation Expectations

When implemented, the controls-feel layer should include:

- Contract and ADR references.
- Settings reference.
- Mouse-button behavior table.
- A/D behavior explanation.
- Cursor policy explanation.
- Manual feel checklist.
- Notes on known differences from polished commercial MMO controls.
- Repo-local camera and movement skill updates.
