# 0004: Character Movement System Architecture

## Status

Accepted

## Date

2026-06-28

## Context

The foundation now has a reusable MMO-style camera system. The next reusable runtime system is character movement: a neutral third-person WASD controller that can be paired with the camera so developers can walk around validation scenes and future playgrounds.

Movement architecture can quickly absorb game-specific player decisions: character assets, animation style, combat-facing behavior, input rebinding, networking, and level design. The foundation needs movement infrastructure that is useful immediately while preserving clean boundaries for later systems.

## Decision

Create the Character Movement System as a reusable runtime system with these initial boundaries:

- Start with a neutral `CharacterBody3D` capsule/proxy.
- Implement MMO-style camera-relative WASD movement before Action-mode behavior.
- Rotate the character toward movement direction in MMO mode.
- Consume read-only camera output from the MMO Camera System.
- Keep Synty humanoid assets, animations, combat, Action-mode strafing, and generated playground content in later slices.

The movement system will have a runtime contract in `docs/runtime_systems/character_movement_system_contract.md` and a repo-local skill draft in `skills/godot-character-movement/SKILL.md`.

## Alternatives Considered

### Build A Playable Demo First

A demo scene would create a faster visual payoff, but it would mix movement, camera, generated level, and possible player assumptions before the system contract is clear.

### Import A Synty Humanoid First

Using a humanoid asset immediately would better approximate a future game, but it introduces scale, rig, skeleton, material, animation, and import questions. Those belong in a later character asset integration slice.

### Implement MMO And Action Movement Together

Supporting both modes immediately would make the API feel complete, but Action mode requires facing and possibly combat assumptions that are not approved yet. The contract should reserve Action mode while implementing MMO movement first.

## Consequences

- Movement work can proceed in thin, verifiable slices.
- The first playable scene remains neutral and reusable.
- The movement system can consume camera output without coupling the camera back to movement.
- Future Synty character integration has a stable movement target to replace the capsule proxy.
- More documentation is required up front, but future implementation agents will have clearer boundaries.
