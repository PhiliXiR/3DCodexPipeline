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
- `validate_playable_camera_movement_scene.gd` headless Godot playable scene validation.
- `validate_generated_neutral_playground_scene.gd` headless Godot playground validation.

This slice proves the neutral capsule/proxy scene, settings resource, controller shell, collision shape, visible proxy, external movement vector hook, camera-relative WASD movement, smooth MMO facing toward movement direction, a playable neutral camera + movement validation scene, and a generated neutral lit playground scene.

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

## Boundaries

- Use a neutral capsule/proxy before Synty humanoid integration.
- Implement MMO-style WASD movement before Action-mode behavior.
- Rotate toward movement direction in MMO mode; do not implement Action-mode camera-facing behavior yet.
- Keep camera orbit, zoom, and collision inside the MMO Camera System.
- Keep generated playgrounds neutral and separate from movement controller implementation.
