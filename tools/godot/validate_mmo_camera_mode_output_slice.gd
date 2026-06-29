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

	var changed_modes: Array[int] = []
	camera_rig.connect("camera_mode_changed", func(camera_mode: int) -> void:
		changed_modes.append(camera_mode)
	)

	camera_rig.call("force_update")
	var mmo_output: Resource = camera_rig.call("get_mode_output") as Resource
	var default_mode: int = camera_rig.call("get_camera_mode") as int
	if default_mode != MMOCameraSettings.CameraMode.MMO:
		failures.append("Default camera mode was not MMO")
	if mmo_output.get("should_face_camera") as bool:
		failures.append("MMO mode incorrectly requested camera-facing character output")
	if not (mmo_output.get("desired_character_facing_direction") as Vector3).is_zero_approx():
		failures.append("MMO mode should not provide a forced character-facing direction")

	var right_mouse_press := InputEventMouseButton.new()
	right_mouse_press.button_index = MOUSE_BUTTON_RIGHT
	right_mouse_press.pressed = true
	camera_rig.call("_unhandled_input", right_mouse_press)
	var rmb_output: Resource = camera_rig.call("get_mode_output") as Resource
	if camera_rig.call("get_camera_mode") as int != MMOCameraSettings.CameraMode.MMO:
		failures.append("RMB look changed the camera mode")
	if not (rmb_output.get("should_face_camera") as bool):
		failures.append("RMB look did not request camera-facing character output")
	if not ((rmb_output.get("desired_character_facing_direction") as Vector3).is_equal_approx(rmb_output.get("camera_planar_forward") as Vector3)):
		failures.append("RMB facing direction did not match camera planar forward")

	var right_mouse_release := InputEventMouseButton.new()
	right_mouse_release.button_index = MOUSE_BUTTON_RIGHT
	right_mouse_release.pressed = false
	camera_rig.call("_unhandled_input", right_mouse_release)
	var post_rmb_output: Resource = camera_rig.call("get_mode_output") as Resource
	if post_rmb_output.get("should_face_camera") as bool:
		failures.append("RMB release did not clear camera-facing character output")

	camera_rig.call("set_camera_mode", MMOCameraSettings.CameraMode.ACTION)
	var action_output: Resource = camera_rig.call("get_mode_output") as Resource
	var action_planar_forward: Vector3 = action_output.get("camera_planar_forward") as Vector3
	var desired_facing: Vector3 = action_output.get("desired_character_facing_direction") as Vector3
	var action_mode: int = camera_rig.call("get_camera_mode") as int
	if action_mode != MMOCameraSettings.CameraMode.ACTION:
		failures.append("Action mode was not applied")
	if not (action_output.get("should_face_camera") as bool):
		failures.append("Action mode did not request camera-facing character output")
	if not desired_facing.is_equal_approx(action_planar_forward):
		failures.append("Action mode facing direction did not match camera planar forward")
	if changed_modes != [MMOCameraSettings.CameraMode.ACTION]:
		failures.append("Camera mode changed signal did not emit the expected mode")

	camera_rig.call("set_camera_mode", MMOCameraSettings.CameraMode.MMO)
	var restored_output: Resource = camera_rig.call("get_mode_output") as Resource
	if restored_output.get("should_face_camera") as bool:
		failures.append("Restored MMO mode still requested camera-facing character output")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera mode output slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
