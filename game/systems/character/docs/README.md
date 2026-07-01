# Character Movement System

This folder is reserved for the reusable third-person character movement foundation.

The movement system is implemented in slices and must remain reusable infrastructure. It should not introduce game-specific character assets, animation, combat, theme, quests, levels, or final input schemes.

Primary references:

- `docs/runtime_systems/character_movement_system_contract.md`
- `docs/runtime_systems/mmo_controls_feel_contract.md`
- `docs/adr/0004-character-movement-system-architecture.md`
- `docs/adr/0005-mmo-controls-feel-layer.md`
- `skills/godot-character-movement/SKILL.md`

## Planned Components

- Movement settings resource.
- Neutral capsule/proxy controller.
- Camera-relative MMO movement.
- Smooth facing toward movement direction.
- Playable camera + movement validation scene.
- Generated neutral lit playground.

## Current Slice

The current implementation includes:

- `CharacterMovementSettings` resource.
- `CharacterMovementController` script.
- `NeutralCharacterCapsule.tscn` reusable neutral capsule scene.
- `CharacterMovementCapsuleTest.tscn` neutral validation scene.
- `PlayableCameraMovementTest.tscn` neutral playable camera + movement validation scene.
- `GeneratedNeutralPlayground.tscn` generated neutral lit playground scene.
- `validate_character_movement_capsule_slice.gd` headless Godot validation.
- `validate_character_movement_camera_relative_slice.gd` headless Godot camera-relative movement validation.
- `validate_character_movement_facing_slice.gd` headless Godot facing validation.
- `validate_character_movement_lateral_mode_slice.gd` headless Godot A/D mode validation.
- `validate_playable_camera_movement_scene.gd` headless Godot playable scene validation.
- `validate_generated_neutral_playground_scene.gd` headless Godot playground validation.

This slice proves the neutral capsule/proxy scene, settings resource, controller shell, collision shape, visible proxy, external movement vector hook, camera-relative WASD movement, smooth MMO facing toward movement direction, RMB camera-facing intent consumption, a playable neutral camera + movement validation scene, and a generated neutral lit playground scene.

The recommended foundation A/D default is `STRAFE`, preserving the current camera-relative capsule behavior. `TURN` is available for MMO-style keyboard turning: A/D rotate the neutral proxy in place and do not produce lateral velocity. RMB-held movement may align character facing toward camera planar forward while movement velocity remains controlled by movement input.

## Default Feel Preset

`default_character_movement_settings.tres` is tuned as a neutral MMO-style playground preset:

- `move_speed = 5.5` for readable capsule traversal in the generated playground.
- `acceleration = 30.0` and `deceleration = 34.0` for responsive start/stop without instant snapping.
- `gravity = 28.0`, `max_fall_speed = 60.0`, and `jump_velocity = 6.0` for stable grounded movement with a small utility hop.
- `turn_speed = 16.0` and `keyboard_turn_speed_degrees = 150.0` for smoother facing and keyboard turning.
- `lateral_input_mode = STRAFE` as the current foundation default.

Future games should override this resource or provide their own preset rather than hard-coding feel changes in the controller.

## Validation

Run the neutral capsule validation:

```powershell
python tools/godot/run_character_movement_capsule_validation.py
```

Run the camera-relative movement validation:

```powershell
python tools/godot/run_character_movement_camera_relative_validation.py
```

Run the facing validation:

```powershell
python tools/godot/run_character_movement_facing_validation.py
```

Run the lateral input mode validation:

```powershell
python tools/godot/run_character_movement_lateral_mode_validation.py
```

Run the playable camera + movement scene validation:

```powershell
python tools/godot/run_playable_camera_movement_validation.py
```

Run the generated playground validation:

```powershell
python tools/godot/run_generated_neutral_playground_validation.py
```

## Manual Test Scene

Open `res://scenes/test/PlayableCameraMovementTest.tscn` in Godot to manually test the current movement and camera stack.

Open `res://scenes/test/GeneratedNeutralPlayground.tscn` for a larger neutral lit walk-around environment.

Expected controls:

- WASD movement through `move_forward`, `move_backward`, `move_left`, and `move_right`.
- Right mouse button camera look from the MMO Camera System.
- Mouse wheel camera zoom from the MMO Camera System.

The MMO Controls Feel Layer is the planned integration point for mouse-button look state, cursor capture, both-buttons movement, and configurable A/D behavior. Movement should consume its read-only movement and facing intent; it should not own camera orbit or cursor policy.

Current RMB behavior:

- Holding RMB keeps camera orbit inside the MMO Camera System.
- Camera mode output exposes camera-facing intent to movement.
- Movement may face the neutral proxy toward camera planar forward when movement input exists.
- LMB-only orbit does not request character-facing intent.

## Generated Playground Maintenance

`GeneratedNeutralPlayground.tscn` is maintained as deterministic generated-style validation geometry made from primitive Godot meshes and colliders. Keep it neutral:

- Use simple floors, boundaries, blocks, columns, lights, and spawn markers.
- Avoid architecture, props, materials, names, or layout choices that imply a final game theme.
- Preserve collision on walkable surfaces, boundaries, and camera test obstacles.

## Input Actions

The default movement settings reference these Godot input actions:

- `move_forward`
- `move_backward`
- `move_left`
- `move_right`
- `jump`

## Boundaries

- Use a neutral capsule/proxy before Synty humanoid integration.
- Implement MMO-style WASD movement before Action-mode behavior.
- Rotate toward movement direction in MMO mode; do not implement Action-mode camera-facing behavior yet.
- Keep camera orbit, zoom, and collision inside the MMO Camera System.
- Keep generated playgrounds neutral and separate from movement controller implementation.
