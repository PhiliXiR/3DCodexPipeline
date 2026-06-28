---
name: godot-mmo-camera
description: Use when building, extending, validating, or documenting the reusable MMO-style third-person camera system.
---

# Godot MMO Camera

## when_to_use

Use this skill when working on the reusable MMO-style third-person camera system in this repository.

Good uses:

- Implementing a camera issue from the `MMO Camera` issue series.
- Updating orbit, mouse-look, zoom, collision, mode output, or extension seams.
- Updating camera docs, ADRs, test scenes, or validation commands.
- Preparing the camera workflow for promotion to a shareable skill.

Do not use this skill for:

- Building a player controller.
- Creating gameplay levels.
- Choosing a theme, character fantasy, combat style, or final input scheme.
- Implementing target lock, shake, or zones before their own approved slices.

## required_context

Before acting, read:

- `AGENTS.md`
- `docs/ARCHITECTURE.md`
- `docs/CODING_STANDARDS.md`
- `docs/runtime_systems/mmo_camera_system_contract.md`
- `docs/adr/0003-mmo-camera-system-architecture.md`
- `game/systems/camera/docs/README.md`

For later implementation slices, also inspect existing files under:

- `game/systems/camera/`
- `game/scenes/test/`
- `tools/godot/run_mmo_camera_orbit_validation.py`
- `tools/godot/validate_mmo_camera_orbit_slice.gd`
- `tools/godot/run_mmo_camera_mouse_look_validation.py`
- `tools/godot/validate_mmo_camera_mouse_look_slice.gd`
- `tools/godot/run_mmo_camera_zoom_validation.py`
- `tools/godot/validate_mmo_camera_zoom_slice.gd`
- `tools/godot/run_mmo_camera_collision_validation.py`
- `tools/godot/validate_mmo_camera_collision_slice.gd`
- `tools/godot/run_mmo_camera_mode_output_validation.py`
- `tools/godot/validate_mmo_camera_mode_output_slice.gd`

## workflow

1. Identify the specific MMO Camera issue slice being implemented.
2. Confirm whether the slice is contract, orbit, mouse look, zoom, collision, mode output, extension seam, or skill finalization work.
3. Keep the change focused on that slice.
4. Preserve modular responsibilities between settings, controller, orbit, zoom, collision, and output adapters.
5. Use a neutral test scene and generic target proxy for verification.
6. Avoid adding player movement or game-specific behavior.
7. Update camera docs and this skill when workflow knowledge changes.
8. Run foundation validators and any camera-specific validation available for the slice.

## validation

Always run:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
python tools/validators/validate_repo_skills.py
```

When camera implementation exists, also run the relevant Godot validation or smoke scene command documented by that slice.

Current neutral orbit validation:

```powershell
python tools/godot/run_mmo_camera_orbit_validation.py
```

Current mouse-look validation:

```powershell
python tools/godot/run_mmo_camera_mouse_look_validation.py
```

Current zoom validation:

```powershell
python tools/godot/run_mmo_camera_zoom_validation.py
```

Current collision validation:

```powershell
python tools/godot/run_mmo_camera_collision_validation.py
```

Current mode output validation:

```powershell
python tools/godot/run_mmo_camera_mode_output_validation.py
```

Expected result:

- Foundation validators pass.
- Camera behavior remains neutral and reusable.
- No gameplay, player controller, level, or theme-specific content is added.
- The repo-local skill remains valid.

## handoff_output

When finished, report:

- MMO Camera issue number and slice name.
- Camera components changed.
- Test scene or validation used.
- Commands run.
- Validation results.
- Any follow-up issue needed.
- Whether the skill or promotion notes changed.

## promotion_notes

Before promoting this skill globally:

- Complete the full camera issue series.
- Exercise the workflow in at least one additional Godot project.
- Replace repository-specific paths with parameters.
- Add portable setup diagrams or examples.
- Clarify which parts are generic camera infrastructure versus optional game integration.
