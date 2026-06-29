---
name: godot-character-movement
description: Use when building, extending, validating, or documenting the reusable MMO-style character movement system.
---

# Godot Character Movement

## when_to_use

Use this skill when working on the reusable third-person MMO-style character movement system in this repository.

Good uses:

- Implementing a character movement issue from the `Character Movement` issue series.
- Updating movement contracts, neutral capsule controller work, camera-relative WASD movement, smooth facing, playable validation scenes, or generated playground support.
- Updating movement docs, ADRs, test scenes, or validation commands.
- Preparing the movement workflow for promotion to a shareable skill.

Do not use this skill for:

- Importing or configuring final Synty humanoid assets before an approved asset integration slice.
- Creating game-specific levels, combat, abilities, quests, classes, factions, lore, or theme.
- Implementing Action-mode strafing or combat-facing movement before its own approved slice.
- Implementing animation trees, root motion, networking, save/load, or input rebinding before approved slices.

## required_context

Before acting, read:

- `AGENTS.md`
- `docs/ARCHITECTURE.md`
- `docs/CODING_STANDARDS.md`
- `docs/runtime_systems/character_movement_system_contract.md`
- `docs/runtime_systems/mmo_camera_system_contract.md`
- `docs/adr/0004-character-movement-system-architecture.md`
- `game/systems/character/docs/README.md`
- `game/systems/camera/docs/README.md`

For later implementation slices, also inspect existing files under:

- `game/systems/character/scripts/character_movement_settings.gd`
- `game/systems/character/scripts/character_movement_controller.gd`
- `game/systems/character/resources/default_character_movement_settings.tres`
- `game/systems/character/scenes/NeutralCharacterCapsule.tscn`
- `game/systems/character/docs/README.md`
- `game/systems/camera/`
- `game/scenes/test/CharacterMovementCapsuleTest.tscn`
- `game/scenes/test/PlayableCameraMovementTest.tscn`
- `game/scenes/test/GeneratedNeutralPlayground.tscn`
- `tools/godot/run_character_movement_capsule_validation.py`
- `tools/godot/validate_character_movement_capsule_slice.gd`
- `tools/godot/run_character_movement_camera_relative_validation.py`
- `tools/godot/validate_character_movement_camera_relative_slice.gd`
- `tools/godot/run_character_movement_facing_validation.py`
- `tools/godot/validate_character_movement_facing_slice.gd`
- `tools/godot/run_playable_camera_movement_validation.py`
- `tools/godot/validate_playable_camera_movement_scene.gd`
- `tools/godot/run_generated_neutral_playground_validation.py`
- `tools/godot/validate_generated_neutral_playground_scene.gd`

## workflow

1. Identify the specific Character Movement issue slice being implemented.
2. Confirm whether the slice is contract, neutral capsule, WASD movement, smooth facing, playable validation scene, generated playground, or skill finalization work.
3. Keep the change focused on that slice.
4. Preserve the dependency direction: movement may consume camera output, but camera must not depend on movement.
5. Use a neutral capsule/proxy and generic validation scenes.
6. Avoid adding final character assets, animation, combat, gameplay, or theme-specific behavior.
7. Update movement docs and this skill when workflow knowledge changes.
8. Run foundation validators and any movement-specific validation available for the slice.

## validation

Always run:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
python tools/validators/validate_repo_skills.py
```

When movement implementation exists, also run the relevant Godot validation command documented by that slice.

Current neutral capsule validation:

```powershell
python tools/godot/run_character_movement_capsule_validation.py
```

Current camera-relative movement validation:

```powershell
python tools/godot/run_character_movement_camera_relative_validation.py
```

Current facing validation:

```powershell
python tools/godot/run_character_movement_facing_validation.py
```

Current playable scene validation:

```powershell
python tools/godot/run_playable_camera_movement_validation.py
```

Current generated playground validation:

```powershell
python tools/godot/run_generated_neutral_playground_validation.py
```

Expected result:

- Foundation validators pass.
- Movement behavior remains neutral and reusable.
- No Synty humanoid, gameplay, combat, level, or theme-specific content is added unless explicitly approved.
- The repo-local skill remains valid.
- Generated Godot cache and `.gd.uid` files remain ignored.

## handoff_output

When finished, report:

- Character Movement issue number and slice name.
- Movement components changed.
- Test scene or validation used.
- Commands run.
- Validation results.
- Any follow-up issue needed.
- Whether the skill or promotion notes changed.

## promotion_notes

Before promoting this skill globally:

- Complete the full movement issue series.
- Exercise the workflow in at least one additional Godot project.
- Replace repository-specific paths with parameters.
- Document Godot version assumptions and how to pass a custom Godot executable path.
- Add portable setup diagrams or examples.
- Clarify which parts are generic movement infrastructure versus optional game integration.
