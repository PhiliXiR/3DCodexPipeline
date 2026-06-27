extends SceneTree

const ASSET_PATH := "res://assets/generated/pipeline_smoke/cube.glb"
const EXPECTED_IMPORTED_ROOT_NAME := "cube"
const EXPECTED_ROOT_NAME := "pipeline_smoke_cube"


func _initialize() -> void:
	var failures: Array[String] = []
	var resource := ResourceLoader.load(ASSET_PATH)
	if resource == null:
		failures.append("Godot could not load %s" % ASSET_PATH)
		_finish(failures)
		return

	if not resource is PackedScene:
		failures.append("Expected %s to load as PackedScene, got %s" % [ASSET_PATH, resource.get_class()])
		_finish(failures)
		return

	var scene := (resource as PackedScene).instantiate()
	if scene == null:
		failures.append("PackedScene instantiated to null")
		_finish(failures)
		return

	if scene.name != EXPECTED_IMPORTED_ROOT_NAME:
		failures.append("Expected imported root node name '%s', got '%s'" % [EXPECTED_IMPORTED_ROOT_NAME, scene.name])

	var mesh_instances := _collect_mesh_instances(scene)
	if mesh_instances.size() != 1:
		failures.append("Expected exactly 1 MeshInstance3D, got %d" % mesh_instances.size())
		_finish(failures)
		return

	var mesh_instance := mesh_instances[0] as MeshInstance3D
	if mesh_instance.name != EXPECTED_ROOT_NAME:
		failures.append("Expected MeshInstance3D name '%s', got '%s'" % [EXPECTED_ROOT_NAME, mesh_instance.name])

	if mesh_instance.mesh == null:
		failures.append("MeshInstance3D has no mesh")
		_finish(failures)
		return

	var aabb := mesh_instance.mesh.get_aabb()
	if not _is_close_vector(aabb.size, Vector3.ONE):
		failures.append("Expected mesh AABB size Vector3(1, 1, 1), got %s" % aabb.size)

	scene.free()
	_finish(failures)


func _collect_mesh_instances(root: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	_collect_mesh_instances_recursive(root, found)
	return found


func _collect_mesh_instances_recursive(node: Node, found: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		found.append(node)

	for child in node.get_children():
		_collect_mesh_instances_recursive(child, found)


func _is_close_vector(actual: Vector3, expected: Vector3) -> bool:
	return is_equal_approx(actual.x, expected.x) and is_equal_approx(actual.y, expected.y) and is_equal_approx(actual.z, expected.z)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("Godot pipeline smoke cube import validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
