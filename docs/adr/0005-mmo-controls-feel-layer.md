# 0005: MMO Controls Feel Layer

## Status

Accepted

## Date

2026-06-29

## Context

The foundation now has a reusable MMO Camera System and Character Movement System. Together they can move a neutral capsule through a generated playground, but the feel is not yet close to long-session MMO controls such as World of Warcraft or Final Fantasy XIV.

The missing behavior is not purely camera behavior or purely movement behavior. It is input coordination: left mouse, right mouse, both mouse buttons, WASD, cursor capture, A/D mode, and how camera-facing intent is communicated to movement.

Without a separate controls-feel contract, camera and movement code could start absorbing each other's responsibilities or introduce game-specific assumptions too early.

## Decision

Create an MMO Controls Feel layer as a reusable coordination contract between input events, the MMO Camera System, and the Character Movement System.

The layer will define:

- LMB camera-only orbit.
- RMB camera orbit plus character-facing intent.
- Optional both-mouse-buttons move-forward intent.
- Configurable A/D turn versus strafe behavior.
- Cursor capture and cursor visibility policy.
- Default feel tuning workflow for the neutral playground.

Camera remains responsible for camera orbit, zoom, collision, and camera output.

Movement remains responsible for desired movement, velocity, gravity, floor collision, and final facing.

The controls-feel layer owns input state and intent coordination only.

## Alternatives Considered

### Add The Behavior Directly To The Camera

This would be fast for RMB mouse-look work, but it would make the camera responsible for movement-facing intent and keyboard behavior.

### Add The Behavior Directly To Movement

This would make movement aware of mouse-button camera states, cursor capture, and camera orbit intent. That would blur input, camera, and movement responsibilities.

### Tune Settings Only

Tuning helps, but it cannot create missing MMO interaction semantics such as LMB-only orbit, RMB-facing intent, both-buttons forward movement, or A/D behavior mode.

## Consequences

- MMO input feel can be improved without turning camera or movement into broad player managers.
- The behavior can be validated as coordination state before deeper feel tuning.
- Future UI/input rebinding systems have a clear integration point.
- More documentation and one more runtime layer are required, but dependency direction stays easier to reason about.
