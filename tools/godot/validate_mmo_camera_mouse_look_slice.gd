extends SceneTree

const SCENE_PATH := "res://scenes/test/MMOCameraOrbitTest.tscn"
const CAMERA_RIG_PATH := "MMOCameraRig"


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

	var camera_rig: Node = scene.get_node_or_null(CAMERA_RIG_PATH)
	if camera_rig == null:
		scene.queue_free()
		_finish(["Missing MMOCameraRig controller"])
		return

	camera_rig.call("force_update")
	var initial_yaw: float = camera_rig.call("get_yaw_degrees") as float
	var initial_pitch: float = camera_rig.call("get_pitch_degrees") as float

	var motion_before_hold := InputEventMouseMotion.new()
	motion_before_hold.relative = Vector2(100.0, 100.0)
	camera_rig.call("_unhandled_input", motion_before_hold)

	if not is_equal_approx(initial_yaw, camera_rig.call("get_yaw_degrees") as float):
		failures.append("Mouse motion changed yaw before right mouse button was held")
	if not is_equal_approx(initial_pitch, camera_rig.call("get_pitch_degrees") as float):
		failures.append("Mouse motion changed pitch before right mouse button was held")

	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_RIGHT
	press.pressed = true
	camera_rig.call("_unhandled_input", press)

	if not camera_rig.call("is_mouse_look_active") as bool:
		failures.append("Right mouse press did not enable mouse look")

	var motion := InputEventMouseMotion.new()
	motion.relative = Vector2(20.0, -10.0)
	camera_rig.call("_unhandled_input", motion)

	if is_equal_approx(initial_yaw, camera_rig.call("get_yaw_degrees") as float):
		failures.append("Mouse-look motion did not update yaw")
	if is_equal_approx(initial_pitch, camera_rig.call("get_pitch_degrees") as float):
		failures.append("Mouse-look motion did not update pitch")

	var settings: Resource = camera_rig.get("settings") as Resource
	var min_pitch: float = settings.get("min_pitch_degrees") as float
	var max_pitch: float = settings.get("max_pitch_degrees") as float
	camera_rig.call("orbit", 0.0, -10000.0)
	var low_pitch: float = camera_rig.call("get_pitch_degrees") as float
	if not is_equal_approx(low_pitch, min_pitch):
		failures.append("Pitch did not clamp to minimum")

	camera_rig.call("orbit", 0.0, 10000.0)
	var high_pitch: float = camera_rig.call("get_pitch_degrees") as float
	if not is_equal_approx(high_pitch, max_pitch):
		failures.append("Pitch did not clamp to maximum")

	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_RIGHT
	release.pressed = false
	camera_rig.call("_unhandled_input", release)

	if camera_rig.call("is_mouse_look_active") as bool:
		failures.append("Right mouse release did not disable mouse look")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera mouse-look slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
