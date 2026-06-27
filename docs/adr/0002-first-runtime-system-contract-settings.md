# 0002: Use Settings As The First Runtime System Contract

## Status

Accepted

## Date

2026-06-27

## Context

The foundation needs a first reusable runtime system contract. The selected system should prove how runtime systems are specified without forcing a game direction.

Candidates such as input, interaction, camera, inventory, dialogue, quests, NPC behavior, weather, and day/night systems are useful, but they can easily imply gameplay, player model, world structure, or genre assumptions too early.

Settings are broadly useful across future games and can remain game-neutral.

## Decision

The first reusable runtime system contract will be the Settings System.

The contract is documented in `docs/runtime_systems/settings_system_contract.md`. It defines purpose, responsibilities, non-goals, data model, API shape, events, integration points, persistence expectations, autoload policy, testing expectations, and open questions.

This ADR approves the contract only. It does not approve implementation yet.

## Alternatives Considered

### Input System

Input is broadly useful, but early input decisions can imply player control models, remapping scope, device support, and gameplay assumptions.

### Interaction System

Interaction is valuable for many games, but it risks implying player presence, world affordances, object targeting, and gameplay verbs.

### Camera System

Camera foundations are useful, but camera architecture can quickly imply game feel, perspective, genre, and controller assumptions.

### Save System

Save infrastructure is reusable, but it depends on knowing what kinds of runtime state and profiles the foundation needs to persist.

## Consequences

- The foundation gets a concrete runtime-system contract without adding gameplay.
- Future runtime systems have a contract template to follow.
- Settings can later support editor and runtime workflows across many possible games.
- Implementation remains deferred until a follow-up issue is approved.
- Some open questions remain around GDScript test framework, definition format, and persistence adapter design.
