"""Validate the Stage 1 Blender-generated cube pipeline outputs."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any


EXPECTED_REPORT = {
    "schema_version": 1,
    "pipeline": "pipeline_smoke_cube",
    "status": "success",
    "source": {
        "type": "generated",
        "generator": "tools/blender/generate_pipeline_smoke_cube.py",
    },
    "outputs": {
        "glb": "game/assets/generated/pipeline_smoke/cube.glb",
    },
    "asset": {
        "name": "pipeline_smoke_cube",
        "dimensions_meters": [1.0, 1.0, 1.0],
        "location": [0.0, 0.0, 0.0],
        "rotation_degrees": [0.0, 0.0, 0.0],
        "scale": [1.0, 1.0, 1.0],
    },
}


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _compare(expected: Any, actual: Any, path: str, failures: list[str]) -> None:
    if isinstance(expected, dict):
        if not isinstance(actual, dict):
            failures.append(f"{path} should be an object")
            return
        for key, expected_value in expected.items():
            if key not in actual:
                failures.append(f"{path}.{key} is missing")
                continue
            _compare(expected_value, actual[key], f"{path}.{key}", failures)
        return

    if actual != expected:
        failures.append(f"{path} expected {expected!r}, got {actual!r}")


def main() -> int:
    root = _repo_root()
    glb_path = root / "game/assets/generated/pipeline_smoke/cube.glb"
    report_path = root / "game/assets/generated/pipeline_smoke/cube.import_report.json"
    failures: list[str] = []

    if not glb_path.is_file():
        failures.append(f"missing GLB output: {glb_path.relative_to(root).as_posix()}")
    elif glb_path.stat().st_size <= 0:
        failures.append(f"GLB output is empty: {glb_path.relative_to(root).as_posix()}")

    if not report_path.is_file():
        failures.append(f"missing import report: {report_path.relative_to(root).as_posix()}")
    else:
        try:
            report = json.loads(report_path.read_text(encoding="utf-8"))
            _compare(EXPECTED_REPORT, report, "report", failures)
        except json.JSONDecodeError as exc:
            failures.append(f"import report is invalid JSON: {exc}")

    if failures:
        print("Pipeline smoke cube validation failed:")
        for failure in failures:
            print(f"- {failure}")
        return 1

    print("Pipeline smoke cube validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
