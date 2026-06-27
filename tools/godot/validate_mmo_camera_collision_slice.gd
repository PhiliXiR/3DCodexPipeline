extends SceneTree

const SCENE_PATH := "res://scenes/test/MMOCameraOrbitTest.tscn"
const CAMERA_RIG_PATH := "MMOCameraRig"
const TARGET_PATH := "TargetProxy"
const CAMERA_PATH := "MMOCameraRig/Camera3D"


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []
	var packed_scene := ResourceLoader.load(SCENE_PATH)
	if packed_scene == null:
		_finish(["Could not load %s" % SCENE_PATH])
		return

	var scene: Node3D = (packed_scene as PackedScene).instantiate()
	root.add_child(scene)

	var camera_rig: Node = scene.get_node_or_null(CAMERA_RIG_PATH)
	var target: Node3D = scene.get_node_or_null(TARGET_PATH) as Node3D
	var camera: Camera3D = scene.get_node_or_null(CAMERA_PATH) as Camera3D
	if camera_rig == null or target == null or camera == null:
		scene.queue_free()
		_finish(["Missing camera rig, target, or camera in collision validation scene"])
		return

	var settings: Resource = camera_rig.get("settings") as Resource
	settings.set("collision_enabled", true)
	settings.set("collision_mask", 1)

	camera_rig.call("set_preferred_distance", settings.get("default_distance") as float)
	camera_rig.call("force_update")
	var unobstructed_distance: float = camera_rig.call("get_actual_distance") as float
	var target_position: Vector3 = target.global_position + Vector3.UP * (settings.get("target_height") as float)
	var blocker := _create_blocker(target_position.lerp(camera.global_position, 0.5))
	scene.add_child(blocker)
	blocker.force_update_transform()

	camera_rig.call("force_update")
	var blocked_distance: float = camera_rig.call("get_actual_distance") as float
	if blocked_distance >= unobstructed_distance:
		failures.append("Camera distance was not reduced by blocking geometry")

	scene.remove_child(blocker)
	blocker.free()

	camera_rig.call("update_camera", 0.016)
	var recovering_distance: float = camera_rig.call("get_actual_distance") as float
	if recovering_distance <= blocked_distance:
		failures.append("Camera distance did not begin recovering after blocker removal")
	if recovering_distance >= unobstructed_distance:
		failures.append("Camera recovery snapped instantly to the preferred distance")

	scene.queue_free()
	_finish(failures)


func _create_blocker(position: Vector3) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = "CameraCollisionBlocker"
	body.collision_layer = 1
	body.collision_mask = 1
	body.position = position

	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(4.0, 4.0, 4.0)
	shape.shape = box
	body.add_child(shape)
	return body


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera collision slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
