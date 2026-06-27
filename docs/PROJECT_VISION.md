# Project Vision

This repository is an AI-first development foundation for future 3D games built with Godot 4, typed GDScript, Synty-style assets, Blender-assisted asset processing, editor tools, and modular reusable systems.

It is not a game yet. It deliberately avoids theme, story, genre, gameplay, player fantasy, and art direction decisions so the foundation can support many future projects.

## Purpose

The purpose of this repository is to create a professional, reusable game development base that makes future prototypes faster and more maintainable.

The foundation should help future projects avoid:

- One-off scripts that become impossible to reuse.
- Manual asset import steps that cannot be repeated reliably.
- Undocumented editor workflows.
- Large manager classes with unclear ownership.
- Game-specific assumptions embedded in generic systems.
- AI agents making inconsistent architectural choices.

## Success Criteria

The foundation is succeeding when:

- A new AI agent can understand the repository from the docs.
- A future game can reuse systems without rewriting the project layout.
- Repetitive work becomes automated through tools, importers, validators, or editor plugins.
- Runtime systems are modular, typed, documented, and testable.
- Asset processing can be repeated and audited.
- Creative direction remains under human control.

## Guiding Values

### Reusability

Systems should be useful across multiple future games. They should not assume genre, setting, tone, camera style, control scheme, or progression model.

### Maintainability

Code and docs should be easy to inspect and change. Prefer small files, clear names, explicit dependencies, and narrow responsibilities.

### Simplicity

Do not build a system before the need is real. A small, clear foundation is more valuable than a large speculative framework.

### Automation

Repeated workflows should become tools. Asset import, validation, project checks, and editor workflows should become reproducible.

### AI Collaboration

The repository should be legible to AI agents. Documentation, naming, ADRs, and validation should reduce ambiguity.

## Human And AI Roles

The human user is the Creative Director and Technical Lead. The human owns creative direction, feature approval, architectural approval, and final decisions about when the foundation becomes a concrete game.

AI agents are careful engineering collaborators. They may recommend architecture, implement approved generic systems, improve tooling, write tests, maintain docs, and propose tradeoffs. They must not invent creative direction.

## Project Boundaries

This repository may eventually support:

- Blender-assisted asset processing.
- A script-generated cube pipeline smoke test that proves asset output contracts without introducing game content.
- Synty-style asset import workflows.
- Godot editor plugins.
- Runtime systems such as input, interaction, inventory, dialogue, quests, saves, audio, settings, UI, camera, weather, day/night, and NPC frameworks.
- Validation and reporting tools.
- Future vertical slices.

These should be introduced in stages. During the foundation phase, the goal is structure, documentation, conventions, and validation, not gameplay.

## Long-Term Outcome

The long-term outcome is a reusable AI-assisted Godot 4 development framework that makes future game creation faster, cleaner, and more enjoyable without locking the project into a theme too early.
