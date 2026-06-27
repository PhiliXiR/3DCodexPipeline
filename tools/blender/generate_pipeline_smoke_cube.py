"""Generate a neutral GLB cube and import report using Blender."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import bpy


ASSET_NAME = "pipeline_smoke_cube"
PIPELINE_NAME = "pipeline_smoke_cube"
SCHEMA_VERSION = 1


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate the pipeline smoke cube.")
    parser.add_argument("--repo-root", required=True)
    parser.add_argument("--output-dir", required=True)
    parser.add_argument("--report-path", required=True)

    if "--" in __import__("sys").argv:
        argv = __import__("sys").argv
        return parser.parse_args(argv[argv.index("--") + 1 :])

    return parser.parse_args()


def _relative_to_repo(path: Path, repo_root: Path) -> str:
    return path.resolve().relative_to(repo_root.resolve()).as_posix()


def _reset_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()


def _create_cube() -> bpy.types.Object:
    bpy.context.scene.unit_settings.system = "METRIC"
    bpy.context.scene.unit_settings.scale_length = 1.0

    bpy.ops.mesh.primitive_cube_add(size=1.0, enter_editmode=False, align="WORLD", location=(0.0, 0.0, 0.0))
    cube = bpy.context.object
    cube.name = ASSET_NAME
    cube.data.name = f"{ASSET_NAME}_mesh"
    cube.rotation_euler = (0.0, 0.0, 0.0)
    cube.scale = (1.0, 1.0, 1.0)
    return cube


def _export_glb(cube: bpy.types.Object, glb_path: Path) -> None:
    glb_path.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.object.select_all(action="DESELECT")
    cube.select_set(True)
    bpy.context.view_layer.objects.active = cube
    bpy.ops.export_scene.gltf(filepath=str(glb_path), export_format="GLB", use_selection=True)


def _write_report(repo_root: Path, glb_path: Path, report_path: Path) -> None:
    report = {
        "schema_version": SCHEMA_VERSION,
        "pipeline": PIPELINE_NAME,
        "status": "success",
        "source": {
            "type": "generated",
            "generator": "tools/blender/generate_pipeline_smoke_cube.py",
        },
        "outputs": {
            "glb": _relative_to_repo(glb_path, repo_root),
        },
        "asset": {
            "name": ASSET_NAME,
            "dimensions_meters": [1.0, 1.0, 1.0],
            "location": [0.0, 0.0, 0.0],
            "rotation_degrees": [0.0, 0.0, 0.0],
            "scale": [1.0, 1.0, 1.0],
        },
    }

    report_path.parent.mkdir(parents=True, exist_ok=True)
    report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")


def main() -> int:
    args = _parse_args()
    repo_root = Path(args.repo_root)
    output_dir = Path(args.output_dir)
    report_path = Path(args.report_path)
    glb_path = output_dir / "cube.glb"

    _reset_scene()
    cube = _create_cube()
    _export_glb(cube, glb_path)
    _write_report(repo_root, glb_path, report_path)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
