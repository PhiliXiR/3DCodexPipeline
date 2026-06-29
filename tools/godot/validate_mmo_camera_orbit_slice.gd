extends SceneTree

const SCENE_PATH := "res://scenes/test/MMOCameraOrbitTest.tscn"
const CAMERA_RIG_PATH := "MMOCameraRig"
const TARGET_PATH := "TargetProxy"


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []
	var packed_scene := ResourceLoader.load(SCENE_PATH)
	if packed_scene == null:
		_finish(["Could not load %s" % SCENE_PATH])
		return

	if not packed_scene is PackedScene:
		_finish(["Expected %s to load as PackedScene" % SCENE_PATH])
		return

	var scene: Node = (packed_scene as PackedScene).instantiate()
	if scene == null:
		_finish(["Test scene instantiated to null"])
		return

	root.add_child(scene)
	var camera_rig: Node = scene.get_node_or_null(CAMERA_RIG_PATH)
	var target: Node3D = scene.get_node_or_null(TARGET_PATH) as Node3D
	if camera_rig == null:
		failures.append("Missing MMOCameraRig controller")
	if target == null:
		failures.append("Missing TargetProxy")

	if not failures.is_empty():
		scene.queue_free()
		_finish(failures)
		return

	camera_rig.call("force_update")
	var camera: Camera3D = camera_rig.get_node_or_null("Camera3D") as Camera3D
	if camera == null:
		failures.append("Missing Camera3D child")
	else:
		var settings: Resource = camera_rig.get("settings") as Resource
		var target_height: float = settings.get("target_height") as float
		var target_focus: Vector3 = target.global_position + Vector3.UP * target_height
		var direction_to_target: Vector3 = (target_focus - camera.global_position).normalized()
		var camera_forward: Vector3 = -camera.global_transform.basis.z
		if camera_forward.dot(direction_to_target) < 0.999:
			failures.append("Camera is not looking at target proxy")

	var preferred_distance: float = camera_rig.call("get_preferred_distance") as float
	var settings: Resource = camera_rig.get("settings") as Resource
	var default_distance: float = settings.get("default_distance") as float
	if not is_equal_approx(preferred_distance, default_distance):
		failures.append("Preferred distance does not match settings default distance")

	var previous_yaw: float = camera_rig.call("get_yaw_degrees") as float
	camera_rig.call("orbit", 10.0, -5.0)
	var updated_yaw: float = camera_rig.call("get_yaw_degrees") as float
	if is_equal_approx(previous_yaw, updated_yaw):
		failures.append("Orbit call did not update yaw")

	var yaw_before_boundary_setup: float = camera_rig.call("get_yaw_degrees") as float
	camera_rig.call("orbit", 179.0 - yaw_before_boundary_setup, 0.0)
	camera_rig.call("force_update")
	var boundary_yaw_before: float = camera_rig.call("get_current_yaw_degrees") as float
	camera_rig.call("orbit", 5.0, 0.0)
	camera_rig.call("update_camera", 0.016)
	var boundary_yaw_after: float = camera_rig.call("get_current_yaw_degrees") as float
	var boundary_step_degrees := absf(rad_to_deg(angle_difference(deg_to_rad(boundary_yaw_before), deg_to_rad(boundary_yaw_after))))
	if boundary_step_degrees > 20.0:
		failures.append("Camera yaw smoothing jumped across the wrap boundary")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera orbit slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
