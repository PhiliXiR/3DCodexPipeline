extends SceneTree

const SCENE_PATH := "res://scenes/test/GeneratedNeutralPlayground.tscn"


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []
	var packed_scene := ResourceLoader.load(SCENE_PATH)
	if packed_scene == null:
		_finish(["Could not load %s" % SCENE_PATH])
		return

	var scene: Node = (packed_scene as PackedScene).instantiate()
	root.add_child(scene)

	if scene.get_node_or_null("SpawnPoint") == null:
		failures.append("Generated playground is missing SpawnPoint")

	if scene.get_node_or_null("NeutralCharacterCapsule") == null:
		failures.append("Generated playground is missing neutral capsule")

	if scene.get_node_or_null("MMOCameraRig") == null:
		failures.append("Generated playground is missing MMO camera rig")

	if scene.get_node_or_null("DirectionalLight3D") == null:
		failures.append("Generated playground is missing directional light")

	var static_body_count := _count_nodes_of_type(scene, "StaticBody3D")
	if static_body_count < 6:
		failures.append("Generated playground should include floor, boundaries, and obstacles")

	if scene.get_node_or_null("Floor/CollisionShape3D") == null:
		failures.append("Generated playground floor is missing collision")

	if scene.get_node_or_null("TallCameraColumn/CollisionShape3D") == null:
		failures.append("Generated playground is missing tall camera collision test geometry")

	scene.queue_free()
	_finish(failures)


func _count_nodes_of_type(root_node: Node, type_name: String) -> int:
	var count := 0
	var stack: Array[Node] = [root_node]
	while not stack.is_empty():
		var current: Node = stack.pop_back()
		if current.is_class(type_name):
			count += 1
		for child in current.get_children():
			stack.append(child)
	return count


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("Generated neutral playground scene validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
