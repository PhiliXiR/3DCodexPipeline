extends SceneTree

class FakeCameraOutput:
	extends Resource

	var camera_mode: int = 0
	var camera_planar_forward: Vector3 = Vector3.FORWARD
	var camera_planar_right: Vector3 = Vector3.RIGHT


class FakeCameraOutputProvider:
	extends Node

	var output := FakeCameraOutput.new()

	func get_mode_output() -> Resource:
		return output


const SCENE_PATH := "res://scenes/test/CharacterMovementCapsuleTest.tscn"
const CAPSULE_PATH := "NeutralCharacterCapsule"
const LATERAL_MODE_STRAFE := 0
const LATERAL_MODE_TURN := 1


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

	var provider := FakeCameraOutputProvider.new()
	scene.add_child(provider)
	capsule.call("set_camera_output_provider", provider)

	var settings: Resource = capsule.get("settings") as Resource
	settings.set("lateral_input_mode", LATERAL_MODE_STRAFE)
	Input.action_press(&"move_right")
	capsule.call("update_movement", 0.016)
	var strafe_direction: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not strafe_direction.is_equal_approx(Vector3.RIGHT):
		failures.append("Strafe mode did not preserve A/D lateral movement")
	if not is_equal_approx(capsule.call("get_turn_input_axis") as float, 0.0):
		failures.append("Strafe mode unexpectedly produced keyboard turn input")

	Input.action_release(&"move_right")
	capsule.velocity = Vector3.ZERO
	capsule.rotation.y = 0.0
	settings.set("lateral_input_mode", LATERAL_MODE_TURN)
	settings.set("keyboard_turn_speed_degrees", 180.0)

	Input.action_press(&"move_right")
	capsule.call("update_movement", 0.1)
	var turn_direction: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not turn_direction.is_zero_approx():
		failures.append("Turn mode produced lateral movement from A/D")
	if capsule.call("get_turn_input_axis") as float <= 0.0:
		failures.append("Turn mode did not expose right turn input")
	if capsule.rotation.y >= 0.0:
		failures.append("Right turn input did not rotate the capsule to the right")

	Input.action_release(&"move_right")
	var yaw_before_action_mode := capsule.rotation.y
	provider.output.camera_mode = 1
	Input.action_press(&"move_left")
	capsule.call("update_movement", 0.1)
	if not is_equal_approx(capsule.rotation.y, yaw_before_action_mode):
		failures.append("Reserved Action mode applied keyboard turn behavior")

	Input.action_release(&"move_left")
	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	Input.action_release(&"move_right")
	Input.action_release(&"move_left")
	if failures.is_empty():
		print("Character movement lateral mode slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
