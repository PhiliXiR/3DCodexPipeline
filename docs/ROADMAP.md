# Roadmap

This roadmap is staged to keep the project generic and reusable before any game direction is selected. Phases are intentionally engineering-focused.

## Phase 1: Project Foundation

Goal: establish the repository as an AI-readable, theme-neutral Godot 4 foundation.

Deliverables:

- Repository structure.
- Godot project shell.
- Core documentation.
- AI collaboration guide.
- Glossary.
- ADR process.
- Initial PRD.
- Project structure validator.
- Documentation contract validator.

Exit criteria:

- A new AI agent can understand the project from docs alone.
- Required folders and docs are validated by automation.
- The ADR workflow includes a reusable template.
- No gameplay, theme, or content direction has been introduced.

## Phase 2: Asset Pipeline Design

Goal: define the repeatable path from source asset packs to Godot-ready processed assets.

Deliverables:

- Source asset conventions.
- Processed asset conventions.
- Blender automation plan.
- GLB export expectations.
- Stage 1 script-generated cube smoke test.
- Collision generation strategy.
- Import report format.
- Asset validation rules.

Exit criteria:

- The pipeline can be described end-to-end before implementation.
- Validation rules are clear enough to automate.
- No game-specific art direction has been chosen.

## Phase 3: Asset Pipeline Implementation

Goal: build the first safe, repeatable asset processing tools.

Deliverables:

- Blender script skeletons.
- Importer skeletons.
- Validator skeletons.
- Report generation.
- Small representative test fixtures.

Exit criteria:

- A sample asset can move through the pipeline with a report.
- Failed validation is understandable.
- Tools are safe to run repeatedly.

## Phase 4: Core Runtime System Contracts

Goal: define contracts for reusable runtime systems before implementation.

Deliverables:

- Candidate system list.
- System boundaries.
- Dependency rules.
- Data contract patterns.
- Testing strategy.
- ADRs for major system boundaries.

Exit criteria:

- The next runtime system can be implemented without guessing its architecture.
- Systems remain genre-neutral.

## Phase 5: Core Runtime Systems

Goal: implement approved reusable systems that unlock broad prototyping value.

Possible systems:

- Input.
- Interaction.
- Camera.
- Save coordination.
- Settings.
- Audio.
- UI framework.

These are candidates, not automatic scope.

Exit criteria:

- Each system has docs, tests or validators, and clear integration points.
- Systems do not depend on a specific game direction.

## Phase 6: Editor Tools

Goal: improve repeatable development workflows inside Godot.

Possible tools:

- Scene validators.
- Asset validators.
- Import helpers.
- Scatter tools.
- Navigation helpers.
- Road, forest, or interior generation tools.

Exit criteria:

- Tools solve concrete workflow needs.
- Tools produce clear output or reports.
- Runtime code is not polluted with editor-only concerns.

## Phase 7: Gameplay Framework

Goal: define reusable gameplay building blocks after the core foundation is stable.

Deliverables:

- Approved gameplay framework scope.
- Generic sample scenes only where needed for verification.
- Clear separation between framework code and game-specific content.

Exit criteria:

- Framework pieces can support multiple possible games.
- Creative direction remains unchosen unless explicitly approved.

## Phase 8: First Vertical Slice

Goal: validate the foundation through a small approved use case.

Deliverables:

- A narrow end-to-end slice using asset pipeline, runtime systems, editor tooling, and validation.
- Gap analysis.
- Follow-up issues.

Exit criteria:

- The foundation has been exercised in a realistic path.
- Missing infrastructure is known.

## Phase 9: Theme Selection

Goal: choose a concrete game direction only after the foundation can support rapid iteration.

Deliverables:

- Approved theme and gameplay direction.
- Game-specific folder strategy.
- Migration plan for content that should not live in framework areas.

Exit criteria:

- Creative direction is explicit and approved.
- Reusable systems remain protected from game-specific drift.

## Current Status

Phase 1 is in progress. The next recommended engineering task is to define asset pipeline conventions with human approval.
