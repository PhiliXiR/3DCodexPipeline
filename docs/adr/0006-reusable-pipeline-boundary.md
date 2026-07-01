# ADR 0006: Reusable Pipeline Boundary

## Status

Accepted

## Context

3DCodexPipeline is a reusable AI-assisted game development foundation. It is
consumed by games such as OneMoreCast through a submodule dependency.

The pipeline should accelerate future games without depending on any one game.
It may contain reusable runtime systems and reusable production tools, but it
must not absorb game-specific design, tuning, content, or feel.

## Decision

3DCodexPipeline owns stable generic runtime systems and reusable production
tools.

Games own game-specific implementation, authored content, tuning, and generated
output.

Potentially reusable systems should usually begin inside a game first. They are
promoted into the pipeline only after gameplay proves the abstraction. Early
breaking changes are allowed, but a promotion is not complete unless the
consuming game is migrated and validated in the same work slice.

## Pipeline Owns

Reusable runtime systems may include:

- Camera systems.
- Character movement systems.
- Input abstractions.
- Generic interaction frameworks.
- Generic save/load frameworks.
- Generic inventory frameworks.
- Generic UI primitives.
- Generic state machines.
- Scene loading and streaming helpers.
- Debug overlays.
- Validation hooks.

Reusable production tools may include:

- Blender import/export automation.
- Mesh cleanup and validation.
- Collision generation.
- LOD generation.
- Terrain and world-generation tools.
- Foliage and decoration tools.
- Navigation and lighting helpers.
- Asset tagging and batch processing.
- AI prompt libraries.
- Agent workflows.
- Documentation and test-generation helpers.

## Pipeline Must Not Own

The pipeline must not depend on OneMoreCast or any other specific game.

It must not own:

- Fish species.
- Fishing-specific casting, bite, lure, reeling, or tension rules.
- Story, dialogue, quests, economy, or progression for a specific game.
- Named places, named items, or branded content.
- Game-specific balance values.
- Hand-authored generated output after a game imports it.

## Runtime Dependencies Versus Generated Output

Stable generic systems are consumed by games as runtime dependencies through the
submodule.

Generated content and one-off scaffolding are copied into the game and become
game-owned. The pipeline owns the tool that generated the output, not the
game-specific result.

## Promotion Rule

A candidate system should be promoted only when:

- It has been proven through real gameplay or production use.
- It no longer requires game-specific terminology.
- Its API is understandable without the originating game.
- Another game can consume it without inheriting domain-specific assumptions.
- The originating game migrates to the promoted version in the same work slice.
- The originating game validates successfully after migration.

Promotion path:

```text
Game-local prototype
  -> reusable candidate
  -> pipeline extraction
  -> consuming-game migration
  -> submodule update
  -> validation
```

## Consequences

The pipeline will grow more slowly but more reliably.

This avoids speculative abstractions while still allowing successful game-local
systems to become reusable platform capabilities. The pipeline remains a working
toolbox shaped by actual games, not a dumping ground for early ideas.
