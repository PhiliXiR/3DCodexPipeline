# Character Movement System

This folder is reserved for the reusable third-person character movement foundation.

The movement system is implemented in slices and must remain reusable infrastructure. It should not introduce game-specific character assets, animation, combat, theme, quests, levels, or final input schemes.

Primary references:

- `docs/runtime_systems/character_movement_system_contract.md`
- `docs/adr/0004-character-movement-system-architecture.md`
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
- `validate_character_movement_capsule_slice.gd` headless Godot validation.

This slice proves the neutral capsule/proxy scene, settings resource, controller shell, collision shape, visible proxy, and external movement vector hook. WASD camera-relative input, smooth facing, playable camera integration, and generated playground scenes are intentionally handled by later issue slices.

## Validation

Run the neutral capsule validation:

```powershell
python tools/godot/run_character_movement_capsule_validation.py
```

## Boundaries

- Use a neutral capsule/proxy before Synty humanoid integration.
- Implement MMO-style WASD movement before Action-mode behavior.
- Keep camera orbit, zoom, and collision inside the MMO Camera System.
- Keep generated playgrounds neutral and separate from movement controller implementation.
