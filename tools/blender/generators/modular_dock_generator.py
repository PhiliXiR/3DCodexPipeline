"""Generate a modular wooden dock section using Blender primitives."""

from __future__ import annotations

import argparse
import json
import random
import sys
from pathlib import Path

import bpy
from mathutils import Vector


SCHEMA_VERSION = 1
GENERATOR_ID = "modular_dock_generator"


def _parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Generate a modular wooden dock section.")
    parser.add_argument("--output-dir", required=True, help="Directory for .blend, .glb, and metadata outputs.")
    parser.add_argument("--name", default="dock_straight_01", help="Base asset name.")
    parser.add_argument("--length", type=float, default=8.0, help="Dock length in meters.")
    parser.add_argument("--width", type=float, default=2.5, help="Dock width in meters.")
    parser.add_argument("--plank-count", type=int, default=12, help="Number of deck planks along the dock.")
    parser.add_argument("--post-count", type=int, default=4, help="Number of post pairs along the dock.")
    parser.add_argument("--seed", type=int, default=7, help="Seed for subtle plank variation.")

    if "--" in sys.argv:
        return parser.parse_args(sys.argv[sys.argv.index("--") + 1 :])

    return parser.parse_args()


def _reset_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()
    bpy.context.scene.unit_settings.system = "METRIC"
    bpy.context.scene.unit_settings.scale_length = 1.0


def _material(name: str, color: tuple[float, float, float, float], roughness: float = 0.8) -> bpy.types.Material:
    mat = bpy.data.materials.new(name)
    mat.diffuse_color = color
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf is not None:
        bsdf.inputs["Base Color"].default_value = color
        bsdf.inputs["Roughness"].default_value = roughness
    return mat


def _cube(name: str, location: tuple[float, float, float], scale: tuple[float, float, float], mat: bpy.types.Material) -> bpy.types.Object:
    bpy.ops.mesh.primitive_cube_add(size=1.0, enter_editmode=False, align="WORLD", location=location)
    obj = bpy.context.object
    obj.name = name
    obj.data.name = f"{name}_mesh"
    obj.dimensions = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    bevel = obj.modifiers.new("small_edge_bevel", "BEVEL")
    bevel.width = 0.025
    bevel.segments = 1
    obj.modifiers.new("weighted_normals", "WEIGHTED_NORMAL")
    return obj


def _make_collection(name: str) -> bpy.types.Collection:
    collection = bpy.data.collections.new(name)
    bpy.context.scene.collection.children.link(collection)
    return collection


def _link_to_collection(obj: bpy.types.Object, collection: bpy.types.Collection) -> None:
    collection.objects.link(obj)
    for existing in obj.users_collection:
        if existing != collection:
            existing.objects.unlink(obj)


def _build_dock(args: argparse.Namespace) -> list[bpy.types.Object]:
    rng = random.Random(args.seed)
    dock_collection = _make_collection(args.name)
    wood = _material("warm_plank_wood", (0.47, 0.31, 0.16, 1.0))
    dark_wood = _material("dark_support_wood", (0.25, 0.16, 0.09, 1.0))
    post_wood = _material("weathered_post_wood", (0.34, 0.23, 0.14, 1.0))

    objects: list[bpy.types.Object] = []
    plank_gap = 0.045
    plank_length = max(0.25, args.length / max(args.plank_count, 1) - plank_gap)
    plank_width = args.width
    plank_height = 0.16
    start_x = -args.length * 0.5 + plank_length * 0.5

    for index in range(args.plank_count):
        x = start_x + index * (plank_length + plank_gap)
        z_variation = rng.uniform(-0.012, 0.018)
        y_offset = rng.uniform(-0.018, 0.018)
        obj = _cube(
            f"{args.name}_plank_{index + 1:02d}",
            (x, y_offset, 0.8 + z_variation),
            (plank_length, plank_width, plank_height),
            wood,
        )
        obj.rotation_euler.z = rng.uniform(-0.008, 0.008)
        _link_to_collection(obj, dock_collection)
        objects.append(obj)

    support_y = args.width * 0.34
    for side_index, y in enumerate((-support_y, support_y), start=1):
        obj = _cube(
            f"{args.name}_stringer_{side_index}",
            (0.0, y, 0.56),
            (args.length + 0.2, 0.16, 0.18),
            dark_wood,
        )
        _link_to_collection(obj, dock_collection)
        objects.append(obj)

    post_pairs = max(args.post_count, 2)
    post_span = args.length * 0.82
    post_start = -post_span * 0.5
    post_spacing = post_span / (post_pairs - 1)
    post_y = args.width * 0.58
    for pair in range(post_pairs):
        x = post_start + post_spacing * pair
        for side_index, y in enumerate((-post_y, post_y), start=1):
            obj = _cube(
                f"{args.name}_post_{pair + 1:02d}_{side_index}",
                (x, y, 0.2),
                (0.18, 0.18, 1.35),
                post_wood,
            )
            _link_to_collection(obj, dock_collection)
            objects.append(obj)

    for cap_index, x in enumerate((-args.length * 0.5, args.length * 0.5), start=1):
        obj = _cube(
            f"{args.name}_end_cap_{cap_index}",
            (x, 0.0, 0.63),
            (0.16, args.width + 0.3, 0.16),
            dark_wood,
        )
        _link_to_collection(obj, dock_collection)
        objects.append(obj)

    empty = bpy.data.objects.new(f"{args.name}_origin", None)
    empty.empty_display_type = "PLAIN_AXES"
    dock_collection.objects.link(empty)
    objects.append(empty)
    return objects


def _add_lighting_and_camera(length: float, width: float) -> None:
    bpy.ops.object.light_add(type="SUN", location=(0.0, 0.0, 8.0))
    sun = bpy.context.object
    sun.name = "preview_sun"
    sun.data.energy = 2.0
    sun.rotation_euler = (0.9, 0.0, -0.65)

    bpy.ops.object.camera_add(location=(length * 0.55, -width * 3.6, 3.4))
    camera = bpy.context.object
    camera.name = "preview_camera"
    target = Vector((0.0, 0.0, 0.55))
    direction = target - camera.location
    camera.rotation_euler = direction.to_track_quat("-Z", "Y").to_euler()
    camera.data.lens = 28
    bpy.context.scene.camera = camera


def _export_glb(objects: list[bpy.types.Object], glb_path: Path) -> None:
    bpy.ops.object.select_all(action="DESELECT")
    for obj in objects:
        if obj.type == "MESH":
            obj.select_set(True)
    glb_path.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.export_scene.gltf(filepath=str(glb_path), export_format="GLB", use_selection=True)


def _write_metadata(args: argparse.Namespace, blend_path: Path, glb_path: Path, metadata_path: Path, object_count: int) -> None:
    metadata = {
        "schema_version": SCHEMA_VERSION,
        "generator": GENERATOR_ID,
        "asset": {
            "name": args.name,
            "type": "modular_dock_section",
            "dimensions_meters": {
                "length": args.length,
                "width": args.width,
            },
            "parameters": {
                "plank_count": args.plank_count,
                "post_count": args.post_count,
                "seed": args.seed,
            },
            "object_count": object_count,
        },
        "outputs": {
            "blend": blend_path.name,
            "glb": glb_path.name,
            "preview": f"{args.name}_preview.png",
        },
    }
    metadata_path.write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")


def _render_preview(preview_path: Path) -> None:
    bpy.context.scene.render.engine = "BLENDER_WORKBENCH"
    bpy.context.scene.display.shading.light = "STUDIO"
    bpy.context.scene.display.shading.color_type = "MATERIAL"
    bpy.context.scene.render.resolution_x = 1280
    bpy.context.scene.render.resolution_y = 720
    bpy.context.scene.render.filepath = str(preview_path)
    bpy.ops.render.render(write_still=True)


def main() -> int:
    args = _parse_args()
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    blend_path = output_dir / f"{args.name}.blend"
    glb_path = output_dir / f"{args.name}.glb"
    metadata_path = output_dir / f"{args.name}.json"
    preview_path = output_dir / f"{args.name}_preview.png"

    _reset_scene()
    objects = _build_dock(args)
    _add_lighting_and_camera(args.length, args.width)
    bpy.ops.wm.save_as_mainfile(filepath=str(blend_path))
    _export_glb(objects, glb_path)
    _render_preview(preview_path)
    _write_metadata(args, blend_path, glb_path, metadata_path, len([obj for obj in objects if obj.type == "MESH"]))

    print(f"Generated {blend_path}")
    print(f"Generated {glb_path}")
    print(f"Generated {metadata_path}")
    print(f"Generated {preview_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
