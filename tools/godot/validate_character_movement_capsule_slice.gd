extends SceneTree

const SCENE_PATH := "res://scenes/test/CharacterMovementCapsuleTest.tscn"
const CAPSULE_PATH := "NeutralCharacterCapsule"


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
	if capsule == null:
		scene.queue_free()
		_finish(["Missing NeutralCharacterCapsule CharacterBody3D"])
		return

	if capsule.get("settings") == null:
		failures.append("Neutral capsule is missing movement settings")

	if capsule.get_node_or_null("CollisionShape3D") == null:
		failures.append("Neutral capsule is missing collision shape")

	if capsule.get_node_or_null("VisualRoot/CapsuleMesh") == null:
		failures.append("Neutral capsule is missing visible capsule proxy")

	if scene.get_node_or_null("Floor/CollisionShape3D") == null:
		failures.append("Capsule test scene is missing floor collision")

	_settle_capsule_on_floor(capsule)
	if not (capsule.call("is_grounded") as bool):
		failures.append("Neutral controller should start grounded in the capsule test scene")

	var jump_signal_count := [0]
	capsule.connect("jump_started", func() -> void:
		jump_signal_count[0] += 1
	)
	capsule.call("request_jump")
	capsule.call("update_movement", 0.016)
	var current_velocity: Vector3 = capsule.call("get_current_velocity") as Vector3
	if current_velocity.y <= 0.0:
		failures.append("Requested grounded jump did not produce upward velocity")
	if jump_signal_count[0] != 1:
		failures.append("Requested grounded jump did not emit jump_started once")

	capsule.call("request_jump")
	capsule.call("update_movement", 0.016)
	if jump_signal_count[0] != 1:
		failures.append("Airborne jump request should not emit a second jump_started signal")

	capsule.call("set_external_movement_vector", Vector3.FORWARD)
	capsule.call("update_movement", 0.016)
	var desired_direction: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_direction.is_equal_approx(Vector3.FORWARD):
		failures.append("External movement vector did not set desired movement direction")

	current_velocity = capsule.call("get_current_velocity") as Vector3
	if Vector2(current_velocity.x, current_velocity.z).length_squared() <= 0.0:
		failures.append("Neutral controller did not produce horizontal velocity from external movement")

	capsule.call("clear_external_movement_vector")
	capsule.call("update_movement", 0.016)
	desired_direction = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_direction.is_zero_approx():
		failures.append("Clearing external movement vector did not clear desired direction")

	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("Character movement capsule slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)


func _settle_capsule_on_floor(capsule: CharacterBody3D) -> void:
	for frame in 12:
		capsule.call("update_movement", 0.016)
		if capsule.call("is_grounded") as bool:
			return
