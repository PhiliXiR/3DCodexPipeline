# Character Movement Contract Reference

The Character Movement System is reusable movement infrastructure.

Current contract:

- Neutral `CharacterBody3D` capsule/proxy first.
- Camera-relative WASD movement.
- MMO mode first.
- Smooth facing toward movement direction.
- Action mode reserved as a future extension point.
- Generated playground separate from movement controller implementation.
- No Synty humanoid integration in the first slices.
- No animation, combat, gameplay level, or theme-specific assumptions.

Primary docs:

- `docs/runtime_systems/character_movement_system_contract.md`
- `docs/adr/0004-character-movement-system-architecture.md`
