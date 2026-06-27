# 0003: MMO Camera System Architecture

## Status

Accepted

## Date

2026-06-27

## Context

The foundation needs a reusable third-person camera system suitable for future 3D games. The requested behavior is an MMO-style orbit camera with mouse look, smooth zoom, collision handling, configurable settings, and future extension support for target lock, camera shake, and camera zones.

Camera architecture can easily drift into game-specific player movement, combat, cinematic behavior, or theme assumptions. The foundation needs the camera as reusable infrastructure while preserving clean integration points for future character systems.

## Decision

Create the MMO Camera System as a reusable runtime system with a modular architecture:

- Camera Settings Resource.
- Camera Controller.
- Orbit Controller.
- Zoom Controller.
- Collision Handler.
- Mode Output Adapter.

The camera will follow a generic target and expose integration outputs for future character-facing behavior. It will not implement player movement or a character controller.

Target lock, camera shake, and camera zones are reserved as extension seams only until later approved slices implement them.

The system contract is documented in `docs/runtime_systems/mmo_camera_system_contract.md`.

## Alternatives Considered

### Single Large Camera Script

A single script would be fast to prototype but would concentrate orbit, input, zoom, collision, and future extensions in one file. This conflicts with the foundation's modularity and skill extraction goals.

### Build Camera And Character Controller Together

This would make the result feel complete sooner, but it would force player movement decisions too early. The camera should expose integration outputs before a future character controller consumes them.

### Cinematic Camera Foundation

Cinematic behavior is useful for some games, but this system is intended for long-session comfort and predictable MMO-style control.

## Consequences

- Camera behavior can be implemented in thin slices.
- Future controller work can consume camera outputs without being coupled to camera internals.
- The system remains reusable across future projects.
- More files are required than a one-script prototype, but responsibilities stay easier to test, document, and turn into a skill.
- Future extension seams must remain documented so they do not become speculative implementation.
