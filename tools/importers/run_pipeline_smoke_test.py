"""Run the Stage 1 Blender-generated cube pipeline smoke test."""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run the Blender cube pipeline smoke test.")
    parser.add_argument("--blender-path", help="Path to blender executable. Defaults to blender on PATH.")
    return parser.parse_args()


def _resolve_blender(blender_path: str | None) -> str:
    if blender_path:
        candidate = Path(blender_path)
        if candidate.is_file():
            return str(candidate)
        raise SystemExit(f"Blender executable not found at --blender-path: {candidate}")

    discovered = shutil.which("blender")
    if discovered:
        return discovered

    raise SystemExit(
        "Blender is required for the pipeline smoke test but was not found on PATH. "
        "Install Blender and add it to PATH, or pass --blender-path \"C:\\Path\\To\\blender.exe\"."
    )


def main() -> int:
    args = _parse_args()
    repo_root = _repo_root()
    blender = _resolve_blender(args.blender_path)
    output_dir = repo_root / "game/assets/generated/pipeline_smoke"
    report_path = output_dir / "cube.import_report.json"
    generator = repo_root / "tools/blender/generate_pipeline_smoke_cube.py"
    validator = repo_root / "tools/validators/validate_pipeline_smoke_cube.py"

    command = [
        blender,
        "--background",
        "--factory-startup",
        "--python",
        str(generator),
        "--",
        "--repo-root",
        str(repo_root),
        "--output-dir",
        str(output_dir),
        "--report-path",
        str(report_path),
    ]

    subprocess.run(command, check=True)
    subprocess.run([sys.executable, str(validator)], check=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
