"""Run Stage 2 validation for the pipeline smoke cube in Godot."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate the pipeline smoke cube through Godot.")
    parser.add_argument("--blender-path", help="Path to blender executable. Passed through to Stage 1.")
    parser.add_argument("--godot-path", help="Path to godot executable. Defaults to godot on PATH.")
    parser.add_argument(
        "--skip-blender",
        action="store_true",
        help="Use existing generated GLB/report outputs instead of regenerating them first.",
    )
    return parser.parse_args()


def _resolve_executable(explicit_path: str | None, executable_name: str, missing_hint: str) -> str:
    if explicit_path:
        candidate = Path(explicit_path)
        if candidate.is_file():
            return str(candidate)
        raise SystemExit(f"{executable_name} executable not found at override path: {candidate}")

    discovered = shutil.which(executable_name)
    if discovered:
        return discovered

    raise SystemExit(missing_hint)


def _run_stage_1(repo_root: Path, blender_path: str | None) -> None:
    runner = repo_root / "tools/importers/run_pipeline_smoke_test.py"
    command = [sys.executable, str(runner)]
    if blender_path:
        command.extend(["--blender-path", blender_path])
    subprocess.run(command, check=True)


def _run_godot_validation(repo_root: Path, godot: str) -> None:
    project_dir = repo_root / "game"
    script_path = repo_root / "tools/godot/validate_pipeline_smoke_cube_import.gd"
    command = [
        godot,
        "--headless",
        "--path",
        str(project_dir),
        "--script",
        str(script_path),
    ]
    subprocess.run(command, check=True)


def main() -> int:
    args = _parse_args()
    repo_root = _repo_root()
    godot = _resolve_executable(
        args.godot_path,
        "godot",
        "Godot is required for Stage 2 pipeline validation but was not found on PATH. "
        "Install Godot and add it to PATH, or pass --godot-path \"C:\\Path\\To\\godot.exe\".",
    )

    if not args.skip_blender:
        _run_stage_1(repo_root, args.blender_path)

    _run_godot_validation(repo_root, godot)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
