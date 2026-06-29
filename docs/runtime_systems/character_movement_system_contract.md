# Character Movement System Contract

## Status

Approved foundation contract. Implementation is split across the `Character Movement` issue series.

## Purpose

The Character Movement System provides a reusable Godot 4 foundation for neutral third-person MMO-style character movement. It exists so future projects can start from predictable WASD movement, camera-relative direction, gravity, floor collision, and smooth facing without choosing a game theme, final character asset, animation style, combat model, or networking model.

This system is movement infrastructure. It is not a complete player feature.

## Responsibilities

The Character Movement System is responsible for:

- Providing a neutral `CharacterBody3D`-based movement foundation.
- Supporting WASD movement input through configurable Godot input action names.
- Translating movement input into camera-relative movement direction using the MMO Camera System output.
- Applying gravity and floor collision through Godot physics.
- Rotating the character proxy toward movement direction in MMO mode.
- Exposing exported movement settings for speed, acceleration, deceleration, gravity, and turn behavior.
- Remaining compatible with a neutral capsule/proxy before final character assets exist.
- Providing validation scenes and command-line checks for movement behavior.
- Reserving Action mode, animation, Synty humanoid integration, networking, and advanced locomotion for later approved slices.

## Non-Goals

The Character Movement System must not:

- Choose a final player character, character fantasy, theme, faction, class, or setting.
- Import or depend on Synty humanoid assets in the first movement slices.
- Implement animation, animation blending, root motion, combat, abilities, interaction, inventory, quests, or UI.
- Implement Action-mode strafing or camera-facing combat movement in the first movement slices.
- Own camera orbit, zoom, collision, or camera settings.
- Own input rebinding or settings persistence.
- Implement networking, prediction, save/load, or multiplayer authority.
- Require a game-specific scene structure.

## Components

### Movement Settings Resource

Defines reusable tuning values used by the movement controller.

Expected settings include:

- Move speed.
- Acceleration.
- Deceleration.
- Gravity.
- Maximum fall speed.
- Turn speed.
- Keyboard turn speed.
- Lateral input mode for A/D behavior.
- Input action names for forward, backward, left, and right.
- Movement mode or reserved mode integration settings.

### Character Movement Controller

Owns the `CharacterBody3D` movement loop. It reads input, asks the camera integration surface for planar directions, computes desired velocity, applies gravity, calls `move_and_slide()`, and rotates the neutral proxy toward movement direction in MMO mode.

The controller should stay narrow. It should not become a broad player manager.

### Neutral Character Proxy

Provides a generic capsule collider and visible proxy mesh for validation. It exists to prove movement and camera integration before final character assets, rigs, and animations are introduced.

### Camera Movement Adapter

Consumes read-only camera-facing data from the MMO Camera System, especially `camera_planar_forward`, `camera_planar_right`, and `camera_mode`.

The movement system may depend on the camera output contract. The camera system must not depend on the movement system.

### Playable Validation Scene

Combines the neutral movement proxy and MMO Camera System in a minimal scene so WASD movement and camera controls can be tested together.

### Generated Playground Scene

Uses movement and camera systems in a larger neutral, lit, walkable test environment. This scene is a tooling and validation playground, not a game level or theme choice.

## Movement Modes

### MMO Mode

MMO mode is the first implemented movement mode.

In MMO mode:

- WASD input maps to camera-relative planar movement.
- In the recommended default, A/D strafe left and right relative to camera orientation.
- When configured for turn mode, A/D rotate the character proxy without producing lateral movement.
- The character rotates toward movement direction, except direct keyboard turn input may rotate the proxy in place.
- When RMB camera-facing intent is active and movement input exists, the character may face camera planar forward while movement direction remains controlled by movement input.
- The camera remains independent and may orbit around the target.
- The controller does not force the character to face camera forward while idle.

### Action Mode

Action mode is reserved as an extension point.

In Action mode, a future slice may support camera-facing movement, strafing, aiming, or combat-style facing. The first movement implementation should document this boundary but not implement Action-mode behavior.

## Data Inputs

The movement system should accept:

- A movement settings resource.
- Godot input actions for movement intent.
- A camera output provider, such as the MMO Camera System mode output.
- Controls-feel movement and facing intent from the MMO Controls Feel Layer.
- Godot physics state through `CharacterBody3D`.
- Optional external desired movement vectors for future AI, replay, or network-driven controllers.

The movement system should not require a specific player scene, final mesh, animation tree, or game state manager.

## Public API Shape

The future implementation should expose an API equivalent to:

```text
set_camera_output_provider(provider)
set_movement_enabled(enabled)
set_external_movement_vector(vector)
clear_external_movement_vector()
get_desired_movement_direction()
get_current_velocity()
get_last_nonzero_movement_direction()
is_moving()
is_grounded()
```

The exact names may evolve during implementation, but the public surface should remain narrow and documented.

## Events

The system may emit typed signals equivalent to:

```text
movement_started()
movement_stopped()
grounded_state_changed(is_grounded)
movement_mode_changed(mode)
```

Signals should notify consumers only. They must not hide game-specific side effects.

## Integration Boundaries

The movement system may read camera output, but it must not control camera orbit, zoom, collision, or target lock.

The movement system may expose movement and grounded state, but animation systems must decide animation blending and root motion in later slices.

The movement system may be used by a playable validation scene, but game-specific levels and mechanics must remain outside this reusable system.

## Controls Feel Integration

The movement system should consume read-only movement and facing intent from the MMO Controls Feel Layer once that layer exists.

Expected controls-feel semantics:

- RMB-held movement may request that the character faces camera planar forward through camera mode output.
- Both mouse buttons may request forward movement without requiring `move_forward` to be pressed.
- A/D behavior is configurable between strafe and turn semantics. The current foundation default is strafe because it preserves the existing neutral capsule behavior and remains easiest to validate before animation and full RMB-facing movement are added.

The movement system remains responsible for translating approved movement intent into velocity, floor interaction, gravity, and character-facing rotation. RMB-facing intent must not change camera orbit ownership or directly mutate movement velocity outside the movement controller.

## Performance Expectations

- Avoid per-frame allocations in hot movement paths.
- Cache node and resource references.
- Keep input, velocity, gravity, and facing calculations deterministic and easy to validate.
- Prefer simple math and explicit state over hidden scene tree lookups.
- Remain stable at common physics tick rates.

## Test And Validation Expectations

Each implementation slice should be verifiable in a neutral test scene.

Validation should cover:

- Controller and settings instantiation.
- Input action mapping.
- Camera-relative movement direction.
- Gravity and floor collision.
- Smooth facing toward movement direction.
- Camera and movement scene integration.
- Generated playground scene loading and collision presence.

Tests should prove external behavior rather than private implementation details.

## Documentation Expectations

When implemented, the system should include:

- System README.
- Scene setup instructions.
- Movement settings reference.
- Input action reference.
- Camera integration notes.
- Neutral proxy explanation.
- Validation scene instructions.
- Generated playground notes.
- Repo-local skill updates.

## Skill Requirement

The repo-local skill draft lives at:

```text
skills/godot-character-movement/SKILL.md
```

The movement system is incomplete until that skill explains how to build, extend, validate, and promote the movement workflow.
