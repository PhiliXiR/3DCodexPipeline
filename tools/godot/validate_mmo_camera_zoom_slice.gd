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
	var settings: Resource = camera_rig.get("settings") as Resource
	var default_distance: float = settings.get("default_distance") as float
	var zoom_speed: float = settings.get("zoom_speed") as float
	var min_distance: float = settings.get("min_distance") as float
	var max_distance: float = settings.get("max_distance") as float

	var wheel_up := InputEventMouseButton.new()
	wheel_up.button_index = MOUSE_BUTTON_WHEEL_UP
	wheel_up.pressed = true
	camera_rig.call("_unhandled_input", wheel_up)
	var zoomed_in_distance: float = camera_rig.call("get_preferred_distance") as float
	if not is_equal_approx(zoomed_in_distance, default_distance - zoom_speed):
		failures.append("Wheel up did not reduce preferred distance by zoom speed")

	var wheel_down := InputEventMouseButton.new()
	wheel_down.button_index = MOUSE_BUTTON_WHEEL_DOWN
	wheel_down.pressed = true
	camera_rig.call("_unhandled_input", wheel_down)
	var zoomed_out_distance: float = camera_rig.call("get_preferred_distance") as float
	if not is_equal_approx(zoomed_out_distance, default_distance):
		failures.append("Wheel down did not increase preferred distance by zoom speed")

	camera_rig.call("set_preferred_distance", -1000.0)
	var low_distance: float = camera_rig.call("get_preferred_distance") as float
	if not is_equal_approx(low_distance, min_distance):
		failures.append("Preferred distance did not clamp to minimum")

	camera_rig.call("set_preferred_distance", 1000.0)
	var high_distance: float = camera_rig.call("get_preferred_distance") as float
	if not is_equal_approx(high_distance, max_distance):
		failures.append("Preferred distance did not clamp to maximum")

	camera_rig.call("set_preferred_distance", default_distance)
	camera_rig.call("force_update")
	camera_rig.call("set_preferred_distance", max_distance)
	camera_rig.call("update_camera", 0.016)
	var actual_after_smooth: float = camera_rig.call("get_actual_distance") as float
	if actual_after_smooth <= default_distance or actual_after_smooth >= max_distance:
		failures.append("Actual distance did not interpolate smoothly toward preferred distance")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera zoom slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
