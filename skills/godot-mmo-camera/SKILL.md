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
- Porting the neutral camera pattern into another Godot 4 project after removing repository-specific paths.

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

- `game/systems/camera/scripts/mmo_camera_settings.gd`
- `game/systems/camera/scripts/mmo_camera_controller.gd`
- `game/systems/camera/scripts/mmo_camera_mode_output.gd`
- `game/systems/camera/scripts/mmo_camera_extension_hooks.gd`
- `game/systems/camera/resources/default_mmo_camera_settings.tres`
- `game/systems/camera/scenes/MMOCameraRig.tscn`
- `game/scenes/test/MMOCameraOrbitTest.tscn`
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
- `tools/godot/run_mmo_camera_extension_hooks_validation.py`
- `tools/godot/validate_mmo_camera_extension_hooks_slice.gd`

## system_map

Current reusable pieces:

- `MMOCameraSettings`: exported tuning values and camera mode configuration.
- `MMOCameraController`: target following, orbit, mouse-look, zoom, collision resolution, mode output, and passive hook coordination.
- `MMOCameraModeOutput`: read-only adapter data for future character systems.
- `MMOCameraExtensionHooks`: passive provider slots for future target lock, camera shake, and camera zone systems.
- `MMOCameraRig.tscn`: reusable rig scene with a `Camera3D`.
- `MMOCameraOrbitTest.tscn`: neutral validation scene with a generic target proxy.

Boundaries:

- Camera code may expose direction, mode, distance, collision, and hook state.
- Character systems own movement input, velocity, turning, animation, networking, and physics.
- Future target lock, shake, and zone work must begin from the passive hooks and add behavior only in approved slices.
- The system must stay theme-neutral and reusable across future 3D projects.

## workflow

1. Identify the specific MMO Camera issue slice being implemented.
2. Confirm whether the slice is contract, orbit, mouse look, zoom, collision, mode output, extension seam, or skill finalization work.
3. Keep the change focused on that slice.
4. Preserve modular responsibilities between settings, controller, mode output, collision, and extension hooks.
5. Use a neutral test scene and generic target proxy for verification.
6. Avoid adding player movement or game-specific behavior.
7. Update camera docs and this skill when workflow knowledge changes.
8. Run foundation validators and any camera-specific validation available for the slice.
9. For future extension seam work, expose passive hooks only until a target lock, shake, or zone behavior slice is explicitly approved.

When extending behavior:

- Add exported settings before hard-coding tunable values.
- Add or update a focused Godot validation script for the behavior slice.
- Prefer read-only output objects or narrow methods over coupling to future gameplay systems.
- Keep test scenes generic; use target proxies and placeholder provider nodes.
- Update `docs/runtime_systems/mmo_camera_system_contract.md` if the public contract changes.
- Update `docs/adr/0003-mmo-camera-system-architecture.md` when the architecture boundary changes.

## validation

Always run:

```powershell
python tools/validators/validate_project_structure.py
python tools/validators/validate_documentation_contract.py
python tools/validators/validate_repo_skills.py
```

For a full camera pass, run:

```powershell
python tools/godot/run_mmo_camera_orbit_validation.py
python tools/godot/run_mmo_camera_mouse_look_validation.py
python tools/godot/run_mmo_camera_zoom_validation.py
python tools/godot/run_mmo_camera_collision_validation.py
python tools/godot/run_mmo_camera_mode_output_validation.py
python tools/godot/run_mmo_camera_extension_hooks_validation.py
```

Run the full pass after changing shared controller behavior. For docs-only changes, foundation validators may be enough if no runtime files changed.

Individual slice commands:

```powershell
python tools/godot/run_mmo_camera_orbit_validation.py
python tools/godot/run_mmo_camera_mouse_look_validation.py
python tools/godot/run_mmo_camera_zoom_validation.py
python tools/godot/run_mmo_camera_collision_validation.py
python tools/godot/run_mmo_camera_mode_output_validation.py
python tools/godot/run_mmo_camera_extension_hooks_validation.py
```

Expected result:

- Foundation validators pass.
- Camera behavior remains neutral and reusable.
- No gameplay, player controller, level, or theme-specific content is added.
- The repo-local skill remains valid.
- Generated Godot cache and `.gd.uid` files remain ignored.

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

- Verify the camera issue series has been completed and closed.
- Exercise the workflow in at least one additional Godot project.
- Replace repository-specific paths with parameters.
- Add portable setup diagrams or examples.
- Clarify which parts are generic camera infrastructure versus optional game integration.
- Replace issue-series language with slice names that make sense outside this repository.
- Document Godot version assumptions and how to pass a custom Godot executable path.
- Include a compact "new project adoption" checklist with required files, scenes, and validation commands.
