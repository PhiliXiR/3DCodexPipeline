# MMO Camera System Contract

## Status

Approved foundation contract. Implementation is split across the `MMO Camera` issue series.

## Purpose

The MMO Camera System provides a reusable third-person orbit camera for Godot 4 projects. It prioritizes comfort, responsiveness, environmental awareness, predictable controls, and long-session usability.

The system is a camera foundation, not a gameplay feature. It must not assume a final game theme, player controller, character rig, combat model, interaction model, or world design.

## Responsibilities

The MMO Camera System is responsible for:

- Following a generic focal target.
- Maintaining a configurable preferred distance from the target.
- Orbiting around the target.
- Supporting right-mouse mouse-look rotation.
- Clamping pitch to configurable limits.
- Supporting smooth mouse wheel zoom.
- Avoiding camera clipping through world geometry.
- Restoring preferred distance smoothly after collision obstruction clears.
- Exposing camera-facing information needed by future character systems.
- Supporting MMO mode and Action mode integration semantics through configuration.
- Reserving extension seams for target lock, camera shake, and camera zones.

## Non-Goals

The MMO Camera System must not:

- Implement a player controller.
- Implement character movement.
- Choose a character model, rig, animation style, or visual theme.
- Implement targeting, camera shake, or camera zones in the first slices.
- Own input rebinding or settings persistence.
- Become a broad gameplay manager.
- Require game-specific scene structure.

## Components

### Camera Settings Resource

Defines the tunable values used by the system.

Expected settings include:

- Default distance.
- Minimum distance.
- Maximum distance.
- Minimum pitch.
- Maximum pitch.
- Rotation sensitivity.
- Zoom speed.
- Follow smoothing.
- Rotation smoothing.
- Collision recovery smoothing.
- Collision buffer.
- Camera mode.

### Camera Controller

Coordinates the camera system and owns the public integration surface. It should be small and delegate orbit, zoom, collision, and future extension behavior to focused collaborators.

### Orbit Controller

Owns yaw, pitch, pitch clamping, and rotation smoothing.

### Zoom Controller

Owns preferred distance, wheel zoom, min/max distance clamping, and zoom interpolation.

### Collision Handler

Owns line or shape checks between the target and desired camera position. It resolves blocked camera placement and smooth recovery toward preferred distance.

### Mode Output Adapter

Exposes camera-facing information for future character systems without implementing character movement.

## Camera Modes

### MMO Mode

The camera rotates independently. Future character systems may rotate characters toward movement direction.

The camera should expose enough directional data for a future movement system to interpret movement relative to camera orientation.

### Action Mode

Future character systems may face characters toward the camera direction.

The camera should expose camera-facing direction without directly rotating the character.

## Data Inputs

The camera should accept:

- A focal target node.
- A `CameraSettings` resource.
- Input events for mouse look and wheel zoom.
- Physics world state for collision checks.

The camera should not require a specific player scene.

## Public API Shape

The future implementation should expose an API equivalent to:

```text
set_target(target)
set_settings(settings)
set_camera_mode(mode)
get_camera_mode()
get_yaw()
get_pitch()
get_preferred_distance()
get_actual_distance()
get_camera_forward()
get_camera_planar_forward()
get_camera_planar_right()
```

The exact names may evolve during implementation, but the public surface should remain narrow and documented.

## Events

The system may emit typed signals equivalent to:

```text
camera_mode_changed(mode)
preferred_distance_changed(distance)
actual_distance_changed(distance)
collision_state_changed(is_colliding)
```

Signals should be integration hooks, not hidden control flow.

## Future Extension Seams

### Target Lock

Reserve a seam for a future target provider. When implemented later, the camera may frame both player and target while preserving orbit and zoom limits.

### Camera Shake

Reserve a seam for additive camera offsets from future shake providers. Shake should be optional and layered after base orbit/zoom/collision placement.

### Camera Zones

Reserve a seam for future zone override providers. Zones may override zoom, pitch, rotation limits, follow speed, and related settings.

## Performance Expectations

- Avoid per-frame allocations in hot paths.
- Keep physics queries minimal.
- Use stable interpolation at high frame rates.
- Keep input response immediate enough for rapid mouse movement.
- Prefer cached references over repeated scene tree lookups.

## Test And Validation Expectations

Each implementation slice should be verifiable in a neutral test scene.

Validation should cover:

- Target following.
- Orbit positioning.
- Pitch clamping.
- Smooth zoom limits.
- Collision obstruction and recovery.
- Mode output semantics.
- Extension seam presence.

Tests should prove external behavior rather than private implementation details.

## Documentation Expectations

When implemented, the system should include:

- System README.
- Scene setup instructions.
- Settings resource reference.
- Neutral test scene explanation.
- Extension seam notes.
- Repo-local skill updates.

## Skill Requirement

The repo-local skill draft lives at:

```text
skills/godot-mmo-camera/SKILL.md
```

The camera system is incomplete until that skill explains how to build, extend, validate, and promote the camera workflow.
