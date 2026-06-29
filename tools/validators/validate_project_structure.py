"""Validate the repository's AI-first Godot foundation structure."""

from __future__ import annotations

from pathlib import Path


REQUIRED_DIRECTORIES = [
    "docs",
    "docs/adr",
    "docs/runtime_systems",
    "game",
    "game/assets",
    "game/autoload",
    "game/characters",
    "game/data",
    "game/scenes",
    "game/systems",
    "game/ui",
    "game/world",
    "game/systems/controls",
    "game/systems/controls/docs",
    "game/systems/controls/scripts",
    "skills",
    "tests",
    "tools",
    "tools/blender",
    "tools/editor",
    "tools/godot",
    "tools/importers",
    "tools/validators",
]

REQUIRED_FILES = [
    "AGENTS.md",
    ".gitignore",
    "docs/ARCHITECTURE.md",
    "docs/ASSET_PIPELINE.md",
    "docs/CODING_STANDARDS.md",
    "docs/FOLDER_STRUCTURE.md",
    "docs/GLOSSARY.md",
    "docs/PRD_AI_FIRST_GAME_FOUNDATION.md",
    "docs/PROJECT_VISION.md",
    "docs/ROADMAP.md",
    "docs/SKILL_LIFECYCLE.md",
    "docs/adr/0000-template.md",
    "docs/adr/0001-ai-first-godot-foundation-structure.md",
    "docs/adr/0002-first-runtime-system-contract-settings.md",
    "docs/adr/0005-mmo-controls-feel-layer.md",
    "docs/adr/README.md",
    "docs/runtime_systems/README.md",
    "docs/runtime_systems/character_movement_system_contract.md",
    "docs/runtime_systems/mmo_camera_system_contract.md",
    "docs/runtime_systems/mmo_controls_feel_contract.md",
    "docs/runtime_systems/settings_system_contract.md",
    "docs/adr/0004-character-movement-system-architecture.md",
    "game/systems/character/docs/README.md",
    "game/systems/character/resources/default_character_movement_settings.tres",
    "game/systems/character/scenes/NeutralCharacterCapsule.tscn",
    "game/systems/character/scripts/character_movement_controller.gd",
    "game/systems/character/scripts/character_movement_settings.gd",
    "game/systems/camera/docs/README.md",
    "game/systems/camera/resources/default_mmo_camera_settings.tres",
    "game/systems/camera/scenes/MMOCameraRig.tscn",
    "game/systems/camera/scripts/mmo_camera_controller.gd",
    "game/systems/camera/scripts/mmo_camera_extension_hooks.gd",
    "game/systems/camera/scripts/mmo_camera_mode_output.gd",
    "game/systems/camera/scripts/mmo_camera_settings.gd",
    "game/systems/controls/docs/README.md",
    "game/systems/controls/scripts/mmo_controls_cursor_policy.gd",
    "game/systems/controls/scripts/mmo_controls_mouse_state.gd",
    "game/scenes/test/CharacterMovementCapsuleTest.tscn",
    "game/scenes/test/GeneratedNeutralPlayground.tscn",
    "game/scenes/test/MMOCameraOrbitTest.tscn",
    "game/scenes/test/PlayableCameraMovementTest.tscn",
    "game/README.md",
    "game/project.godot",
    "skills/README.md",
    "skills/TEMPLATE_SKILL.md",
    "skills/godot-asset-pipeline-smoke/SKILL.md",
    "skills/godot-asset-pipeline-smoke/references/pipeline_contract.md",
    "skills/godot-character-movement/SKILL.md",
    "skills/godot-character-movement/references/movement_contract.md",
    "skills/godot-mmo-camera/SKILL.md",
    "skills/godot-mmo-camera/references/camera_contract.md",
    "tests/README.md",
    "tools/README.md",
    "tools/blender/generate_pipeline_smoke_cube.py",
    "tools/godot/validate_pipeline_smoke_cube_import.gd",
    "tools/godot/run_character_movement_capsule_validation.py",
    "tools/godot/run_character_movement_camera_relative_validation.py",
    "tools/godot/run_character_movement_facing_validation.py",
    "tools/godot/run_generated_neutral_playground_validation.py",
    "tools/godot/run_playable_camera_movement_validation.py",
    "tools/godot/run_mmo_camera_orbit_validation.py",
    "tools/godot/run_mmo_camera_mouse_look_validation.py",
    "tools/godot/run_mmo_camera_zoom_validation.py",
    "tools/godot/run_mmo_camera_collision_validation.py",
    "tools/godot/run_mmo_camera_mode_output_validation.py",
    "tools/godot/run_mmo_camera_extension_hooks_validation.py",
    "tools/godot/run_mmo_controls_cursor_policy_validation.py",
    "tools/godot/run_mmo_controls_mouse_state_validation.py",
    "tools/godot/validate_mmo_camera_orbit_slice.gd",
    "tools/godot/validate_mmo_camera_mouse_look_slice.gd",
    "tools/godot/validate_mmo_camera_zoom_slice.gd",
    "tools/godot/validate_mmo_camera_collision_slice.gd",
    "tools/godot/validate_mmo_camera_mode_output_slice.gd",
    "tools/godot/validate_mmo_camera_extension_hooks_slice.gd",
    "tools/godot/validate_mmo_controls_cursor_policy_slice.gd",
    "tools/godot/validate_mmo_controls_mouse_state_slice.gd",
    "tools/godot/validate_character_movement_capsule_slice.gd",
    "tools/godot/validate_character_movement_camera_relative_slice.gd",
    "tools/godot/validate_character_movement_facing_slice.gd",
    "tools/godot/validate_generated_neutral_playground_scene.gd",
    "tools/godot/validate_playable_camera_movement_scene.gd",
    "tools/importers/run_godot_pipeline_smoke_import.py",
    "tools/importers/run_pipeline_smoke_test.py",
    "tools/validators/validate_documentation_contract.py",
    "tools/validators/validate_pipeline_smoke_cube.py",
    "tools/validators/validate_project_structure.py",
    "tools/validators/validate_repo_skills.py",
]

FORBIDDEN_FOUNDATION_FILES = [
    "game/scenes/Player.tscn",
    "game/scenes/Main.tscn",
    "game/player",
    "game/enemies",
    "game/levels",
]


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _missing_directories(root: Path) -> list[str]:
    return [path for path in REQUIRED_DIRECTORIES if not (root / path).is_dir()]


def _missing_files(root: Path) -> list[str]:
    return [path for path in REQUIRED_FILES if not (root / path).is_file()]


def _unexpected_foundation_files(root: Path) -> list[str]:
    return [path for path in FORBIDDEN_FOUNDATION_FILES if (root / path).exists()]


def main() -> int:
    root = _repo_root()
    failures: list[str] = []

    for path in _missing_directories(root):
        failures.append(f"missing directory: {path}")

    for path in _missing_files(root):
        failures.append(f"missing file: {path}")

    for path in _unexpected_foundation_files(root):
        failures.append(f"foundation phase should not include: {path}")

    if failures:
        print("Project structure validation failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Project structure validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
