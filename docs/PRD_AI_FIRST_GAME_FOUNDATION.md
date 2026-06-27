# PRD: AI-First Game Foundation

## Problem Statement

The project needs a clean, reusable foundation for future 3D games before any specific game is chosen. Without a strong foundation, future prototypes will likely accumulate one-off scripts, theme-specific assumptions, manual asset steps, undocumented editor workflows, and hard-to-maintain systems.

The user needs a professional Godot 4 project base that AI agents can understand and extend over time while preserving the user's control over creative direction and major architecture decisions.

## Solution

Create and evolve an AI-first Godot 4 game development foundation focused on modular architecture, typed GDScript, reusable systems, Synty-style asset processing, Blender-assisted import automation, Godot editor tools, validators, and documentation.

The foundation must remain genre-neutral and gameplay-neutral until the user approves a concrete direction. The repository should make future engineering work easier by establishing clear folder responsibilities, coding standards, agent guidance, and staged roadmap decisions.

## User Stories

1. As the Creative Director, I want the repository to avoid genre and theme assumptions, so that I can choose the creative direction later.
2. As the Technical Lead, I want a clear project structure, so that future systems have obvious places to live.
3. As the Technical Lead, I want documentation for architecture and folder responsibilities, so that contributors can understand the foundation quickly.
4. As the Technical Lead, I want AI agents to follow explicit repository rules, so that automated work remains consistent with project goals.
5. As an AI agent, I want an `AGENTS.md` guide, so that I know what to build, what to avoid, and how to communicate changes.
6. As an AI agent, I want coding standards for typed GDScript, so that future code follows consistent Godot conventions.
7. As an AI agent, I want dependency direction documented, so that reusable systems do not depend on future game-specific content.
8. As an AI agent, I want folder responsibilities documented, so that I do not create duplicate or misplaced systems.
9. As a future gameplay developer, I want generic runtime system folders, so that approved systems such as input, interaction, inventory, dialogue, saves, audio, and UI can be added cleanly.
10. As a future tools programmer, I want dedicated tooling folders, so that Blender scripts, Godot helpers, editor plugins, importers, and validators stay separated.
11. As a future asset pipeline developer, I want a clear place for Blender automation, so that Synty-style asset processing can be automated later.
12. As a future asset pipeline developer, I want importers and validators separated, so that asset transformation and asset quality checks have clear responsibilities.
13. As a future editor tools developer, I want an editor tooling area, so that plugins such as scatter tools, road tools, forest tools, and scene validators can be built without mixing with runtime code.
14. As a future systems developer, I want reusable systems to be data-driven, so that content can vary across many future games.
15. As a future systems developer, I want small component-oriented scripts, so that behavior remains easy to inspect, reuse, and refactor.
16. As a future systems developer, I want guidance on autoloads, so that global services do not become giant manager objects.
17. As a future tester, I want a tests area, so that reusable systems, tools, validators, and importers can gain regression coverage.
18. As the Technical Lead, I want a staged roadmap, so that foundation, asset pipeline, core systems, editor tools, gameplay framework, vertical slice, and theme selection happen in the right order.
19. As the Creative Director, I want gameplay and player implementation out of scope for the foundation phase, so that engineering does not accidentally choose a game direction.
20. As an AI collaborator, I want documentation updates required when architecture changes, so that the repository stays understandable over years of iteration.
21. As a future project owner, I want the Godot project shell to exist, so that the foundation can later be opened and extended in Godot 4.
22. As a future release engineer, I want automation-first conventions, so that repetitive setup, import, validation, and build tasks can become scripts instead of manual checklists.
23. As a future content developer, I want processed assets separated from tooling, so that imported game assets do not get mixed with pipeline implementation.
24. As a future AI agent, I want clear "things to avoid," so that I do not hardcode game-specific logic or invent creative content.
25. As the Technical Lead, I want change proposals to include tradeoffs, so that architectural decisions remain deliberate.

## Implementation Decisions

- The repository is treated as a reusable game development framework, not a single-game prototype.
- The Godot project root lives under the game area, keeping runtime project files separate from repository-level documentation and tooling.
- Documentation is first-class and includes project vision, architecture, folder structure, coding standards, roadmap, and AI agent guidance.
- Tooling is split by responsibility: Blender automation, Godot command-line helpers, editor plugins, importers, and validators.
- Runtime Godot areas are split into assets, characters, world, UI, systems, data, scenes, and autoloads.
- Empty folders are preserved with placeholder files so the intended structure survives version control.
- The project starts with a minimal Godot 4 project shell, but no gameplay scenes, player controller, levels, assets, or theme-specific content.
- Future runtime systems should be added only when approved and should remain data-driven and genre-neutral.
- Autoloads are allowed only for stable global services with small APIs.
- Future AI workflow guidance may live in the skills area, while immediate agent behavior is governed by the root agent guide.
- The roadmap delays theme selection until after the reusable foundation, asset pipeline, core systems, editor tooling, gameplay framework, and first vertical slice are validated.

## Testing Decisions

- Good tests should verify external behavior and project contracts, not private implementation details.
- The first testing seam should be a project structure validator that confirms required folders and documentation exist.
- The next testing seam should be documentation/architecture validation, checking that core docs and agent guidance remain present and internally consistent.
- Future asset pipeline tests should validate import reports, transform normalization expectations, naming conventions, collision output expectations, and processed asset placement.
- Future Godot system tests should cover reusable system contracts at the highest practical level, such as scene behavior or public resource APIs, before testing internal helper functions.
- Future editor tool tests should verify generated outputs, validation reports, or scene changes rather than editor UI implementation details.
- Future data-driven systems should include schema validation and representative data fixtures.
- Existing prior art is limited because this is the initial foundation. The current best testing target is the repository contract itself.

## Out of Scope

- Choosing a game genre, theme, story, setting, tone, or art direction.
- Creating gameplay.
- Creating a player controller.
- Creating enemies, NPCs, quests, items, levels, or interactive content.
- Importing or generating actual art assets.
- Building Blender pipeline scripts.
- Building Godot editor plugins.
- Implementing runtime systems such as inventory, dialogue, interaction, save data, weather, day/night, or audio management.
- Creating a vertical slice.
- Optimizing for a specific future game before one is approved.

## Further Notes

The immediate next engineering task should be a repository structure validator. It should encode the foundation contract in automation and give future AI agents a fast way to check whether their changes preserved the intended architecture.

Publication to the issue tracker is currently blocked because this workspace does not expose a usable Git repository or remote issue tracker from the current path.
