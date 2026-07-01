extends SceneTree

const SCENE_PATH := "res://scenes/test/PlayableCameraMovementTest.tscn"
const CAPSULE_PATH := "NeutralCharacterCapsule"
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

	var capsule: CharacterBody3D = scene.get_node_or_null(CAPSULE_PATH) as CharacterBody3D
	var camera_rig: Node = scene.get_node_or_null(CAMERA_RIG_PATH)
	if capsule == null or camera_rig == null:
		scene.queue_free()
		_finish(["Missing capsule or camera rig in playable validation scene"])
		return

	camera_rig.call("force_update")
	var mode_output: Resource = camera_rig.call("get_mode_output") as Resource
	if mode_output == null:
		failures.append("Camera rig did not provide mode output")

	var camera_settings: Resource = camera_rig.get("settings") as Resource
	if not is_equal_approx(camera_settings.get("default_distance") as float, 7.0):
		failures.append("Playable scene did not use the default MMO camera feel preset")
	if not is_equal_approx(camera_settings.get("rotation_sensitivity") as float, 0.12):
		failures.append("Playable scene did not use the tuned camera sensitivity")

	var movement_settings: Resource = capsule.get("settings") as Resource
	if not is_equal_approx(movement_settings.get("move_speed") as float, 5.5):
		failures.append("Playable scene did not use the default character movement feel preset")
	if not is_equal_approx(movement_settings.get("turn_speed") as float, 16.0):
		failures.append("Playable scene did not use the tuned movement turn speed")

	Input.action_press(&"move_forward")
	capsule.call("update_movement", 0.016)
	var desired_direction: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if desired_direction.length_squared() <= 0.0001:
		failures.append("Capsule did not receive camera-relative movement input")

	camera_rig.call("force_update")
	var camera_target_height: float = camera_settings.get("target_height") as float
	var expected_target_position := capsule.global_position + Vector3.UP * camera_target_height
	if camera_rig.global_position.distance_to(expected_target_position) > 0.05:
		failures.append("Camera rig did not follow the capsule target")

	if scene.get_node_or_null("Floor/CollisionShape3D") == null:
		failures.append("Playable validation scene is missing floor collision")

	if scene.get_node_or_null("CameraCollisionObstacle/CollisionShape3D") == null:
		failures.append("Playable validation scene is missing a camera collision obstacle")

	Input.action_release(&"move_forward")
	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	Input.action_release(&"move_forward")
	if failures.is_empty():
		print("Playable camera movement scene validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
