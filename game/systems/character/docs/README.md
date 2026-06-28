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

The current slice defines the runtime contract and architecture boundary only.

Implementation is intentionally deferred to later `Character Movement` issues.

## Boundaries

- Use a neutral capsule/proxy before Synty humanoid integration.
- Implement MMO-style WASD movement before Action-mode behavior.
- Keep camera orbit, zoom, and collision inside the MMO Camera System.
- Keep generated playgrounds neutral and separate from movement controller implementation.
