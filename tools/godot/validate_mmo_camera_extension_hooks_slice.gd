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
	var distance_before: float = camera_rig.call("get_actual_distance") as float
	var yaw_before: float = camera_rig.call("get_yaw_degrees") as float
	var pitch_before: float = camera_rig.call("get_pitch_degrees") as float

	var target_lock_provider := Node.new()
	target_lock_provider.name = "TargetLockProviderPlaceholder"
	var camera_shake_provider := Node.new()
	camera_shake_provider.name = "CameraShakeProviderPlaceholder"
	var camera_zone_provider := Node.new()
	camera_zone_provider.name = "CameraZoneProviderPlaceholder"
	scene.add_child(target_lock_provider)
	scene.add_child(camera_shake_provider)
	scene.add_child(camera_zone_provider)

	camera_rig.call("configure_extension_hooks", target_lock_provider, camera_shake_provider, camera_zone_provider)
	var hooks: Resource = camera_rig.call("get_extension_hooks") as Resource
	if not (hooks.call("has_target_lock_provider") as bool):
		failures.append("Target lock provider hook was not registered")
	if not (hooks.call("has_camera_shake_provider") as bool):
		failures.append("Camera shake provider hook was not registered")
	if not (hooks.call("has_camera_zone_provider") as bool):
		failures.append("Camera zone provider hook was not registered")

	camera_rig.call("force_update")
	var distance_after: float = camera_rig.call("get_actual_distance") as float
	var yaw_after: float = camera_rig.call("get_yaw_degrees") as float
	var pitch_after: float = camera_rig.call("get_pitch_degrees") as float
	if not is_equal_approx(distance_after, distance_before):
		failures.append("Extension hooks changed camera distance")
	if not is_equal_approx(yaw_after, yaw_before):
		failures.append("Extension hooks changed camera yaw")
	if not is_equal_approx(pitch_after, pitch_before):
		failures.append("Extension hooks changed camera pitch")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO camera extension hooks slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
