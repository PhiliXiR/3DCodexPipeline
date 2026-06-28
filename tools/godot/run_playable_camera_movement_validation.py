"""Run Godot validation for the playable camera movement scene."""

from __future__ import annotations

import argparse
import shutil
import subprocess
from pathlib import Path


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Validate the playable camera movement scene.")
    parser.add_argument("--godot-path", help="Path to godot executable. Defaults to godot on PATH.")
    return parser.parse_args()


def _resolve_godot(godot_path: str | None) -> str:
    if godot_path:
        candidate = Path(godot_path)
        if candidate.is_file():
            return str(candidate)
        raise SystemExit(f"Godot executable not found at --godot-path: {candidate}")

    discovered = shutil.which("godot")
    if discovered:
        return discovered

    raise SystemExit(
        "Godot is required for playable scene validation but was not found on PATH. "
        "Install Godot and add it to PATH, or pass --godot-path \"C:\\Path\\To\\godot.exe\"."
    )


def main() -> int:
    args = _parse_args()
    repo_root = _repo_root()
    godot = _resolve_godot(args.godot_path)
    script_path = repo_root / "tools/godot/validate_playable_camera_movement_scene.gd"
    project_dir = repo_root / "game"

    subprocess.run(
        [
            godot,
            "--headless",
            "--path",
            str(project_dir),
            "--script",
            str(script_path),
            "--quit-after",
            "5",
        ],
        check=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
