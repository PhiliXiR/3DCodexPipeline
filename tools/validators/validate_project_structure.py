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
    "docs/adr/README.md",
    "docs/runtime_systems/README.md",
    "docs/runtime_systems/settings_system_contract.md",
    "game/README.md",
    "game/project.godot",
    "skills/README.md",
    "skills/TEMPLATE_SKILL.md",
    "skills/godot-asset-pipeline-smoke/SKILL.md",
    "skills/godot-asset-pipeline-smoke/references/pipeline_contract.md",
    "tests/README.md",
    "tools/README.md",
    "tools/blender/generate_pipeline_smoke_cube.py",
    "tools/godot/validate_pipeline_smoke_cube_import.gd",
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
