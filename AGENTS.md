# AI Collaboration Guide

This repository is an AI-first foundation for future 3D games built with Godot 4. It is not a game yet. Agents must preserve the foundation as reusable infrastructure and must not choose a genre, theme, story, visual direction, gameplay loop, or content direction without explicit human approval.

The highest priority is to make future development easier for both humans and AI agents through clear architecture, small modules, typed code, automation, validation, and durable documentation.

All foundation work must remain theme-neutral until the human Creative Director approves a concrete game direction.

## Operating Model

The human user is the Creative Director and Technical Lead.

The human decides:

- Creative direction.
- Gameplay direction.
- Feel and style.
- Major architecture approvals.
- Feature approval.
- When a generic foundation system becomes project-specific content.

AI agents are engineering collaborators.

Agents may:

- Improve architecture and documentation.
- Add reusable infrastructure after the scope is clear.
- Write typed GDScript.
- Add tests, validators, importers, and editor tooling.
- Refactor toward clearer boundaries.
- Propose implementation options and tradeoffs.

Agents must not:

- Invent lore, factions, characters, quests, items, levels, worlds, or themes.
- Create gameplay before it is approved.
- Add placeholder game mechanics to "prove" the structure.
- Hardcode assumptions about genre, camera style, player form, combat, inventory, dialogue, world scale, or progression.
- Hide important behavior in undocumented editor state.
- Make broad architecture changes without explaining why.

## Required Reading Before Work

Before changing architecture, tools, systems, or docs, read:

- `docs/PROJECT_VISION.md`
- `docs/ARCHITECTURE.md`
- `docs/FOLDER_STRUCTURE.md`
- `docs/CODING_STANDARDS.md`
- `docs/GLOSSARY.md`
- Relevant ADRs in `docs/adr/`

If a term is unclear, prefer updating `docs/GLOSSARY.md` over inventing a competing name.

## Required Validation

After changing foundation structure or documentation, run:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
python tools/validators/validate_repo_skills.py
```

If a validator fails, either fix the repository or update the validator and docs together when the project contract has intentionally changed.

## Project Philosophy

- Build a professional game development foundation, not a single-game prototype.
- Keep systems generic until a specific future game is approved.
- Prefer small, composable modules over giant managers.
- Prefer data-driven configuration over hardcoded content.
- Automate repetitive workflows.
- Validate assumptions with tools and tests.
- Document architectural intent near the decisions that depend on it.
- Keep the repository understandable to a new AI agent with no prior conversation context.

## Current Phase Rules

The repository is in the foundation phase.

Allowed:

- Documentation.
- Project organization.
- Validators.
- Tool skeletons.
- Godot project setup.
- Generic architecture decisions.
- Test infrastructure.

Not allowed yet:

- Player controllers.
- Enemies or NPCs.
- Levels or maps.
- Items, quests, dialogue content, abilities, combat, or progression.
- Theme-specific assets.
- Game-specific UI.
- Vertical slice content.

## Architecture Principles

### Modularity

Systems should be independently understandable. Prefer narrow APIs, explicit dependencies, and small files.

### Composition

Prefer composition through nodes, resources, signals, and small scripts. Use inheritance only when the relationship is stable and clear.

### Data-Driven Design

Systems should accept data definitions instead of embedding content. Use Godot `Resource` classes when editor integration matters, and external data files when bulk editing or pipeline tools benefit from them.

### Dependency Direction

Generic foundation code must not depend on game-specific content. Dependencies should generally flow from specific features toward generic systems, not the reverse.

### Automation First

If a workflow will be repeated, prefer a tool, validator, importer, or report over manual instructions.

### Documentation As Infrastructure

Docs are part of the architecture. If behavior or boundaries change, update the docs in the same change.

## Coding Rules

- Use Godot 4.x.
- Use typed GDScript.
- Prefer explicit parameter and return types.
- Keep scripts focused, usually 100-300 lines.
- One script should have one clear responsibility.
- Prefer clear code over clever code.
- Keep runtime scripts separate from editor and pipeline scripts.
- Use comments to explain intent, constraints, and non-obvious Godot lifecycle behavior.
- Avoid comments that merely restate the code.

## Naming Conventions

- Files and folders: `snake_case`.
- GDScript classes: `PascalCase`.
- Variables and functions: `snake_case`.
- Signals: event-style `snake_case`, such as `interaction_started`.
- Constants: `UPPER_SNAKE_CASE`.
- Scene files: `PascalCase.tscn` for reusable scene classes.
- Resource files: descriptive `snake_case` names.
- Tool scripts: name by action and target, such as `validate_project_structure`.

Names should describe generic responsibilities. Avoid names that imply genre, lore, story, player fantasy, or final game direction.

## Preferred Patterns

- Small scene components with focused scripts.
- Resources for reusable configuration and data definitions.
- Signals for decoupled communication between peer systems.
- Explicit setup methods or exported references for required dependencies.
- Autoloads only for stable global services with small APIs.
- Editor plugins for repeatable editor workflows.
- Validators for project, asset, scene, and data quality.
- Import reports for automated asset pipeline work.
- ADRs for durable architecture decisions.

## Things To Avoid

- Theme-specific names in reusable systems.
- Direct references from low-level foundation code to high-level game features.
- Hidden dependencies on brittle scene tree paths.
- Large inheritance hierarchies.
- Broad singleton managers.
- One-off scripts that duplicate reusable tool behavior.
- Unvalidated asset import conventions.
- Silent failures in tools, importers, or validators.
- Adding systems "just in case" without a near-term engineering need.

## Change Workflow

When making a change:

1. Read the relevant docs and ADRs.
2. Identify whether the work is foundation, tooling, runtime system, or game-specific content.
3. Keep the change as small as practical.
4. Update documentation when boundaries, vocabulary, or workflow expectations change.
5. Add tests or validators when behavior can regress.
6. Explain what changed, why, alternatives considered, and tradeoffs.

## Proposing Changes

When proposing a change, include:

- Engineering goal.
- Scope.
- Files or modules affected.
- Alternatives considered.
- Tradeoffs.
- Testing or validation approach.
- Documentation updates needed.

If the change would introduce creative direction or gameplay assumptions, stop and ask for approval.

## Documentation Expectations

- Update `docs/PROJECT_VISION.md` when project purpose or collaboration model changes.
- Update `docs/ARCHITECTURE.md` when module boundaries or dependency direction changes.
- Update `docs/FOLDER_STRUCTURE.md` when folders are added, removed, or repurposed.
- Update `docs/CODING_STANDARDS.md` when code conventions evolve.
- Update `docs/ROADMAP.md` when project phases or sequencing changes.
- Update `docs/GLOSSARY.md` when vocabulary changes or new reusable concepts are introduced.
- Update `docs/SKILL_LIFECYCLE.md` when reusable-system skill expectations change.
- Add or update an ADR in `docs/adr/` when a decision affects architecture, dependency direction, tooling strategy, data shape, or long-term maintainability.

## Completion Reports

When finishing work, report:

- What changed.
- Why it changed.
- What was intentionally not changed.
- How it was verified.
- Recommended next engineering task.

Keep reports concise, specific, and free of invented creative direction.
