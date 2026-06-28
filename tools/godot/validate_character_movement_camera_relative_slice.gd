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

	Input.action_press(&"move_forward")
	capsule.call("update_movement", 0.016)
	var desired_forward: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_forward.is_equal_approx(Vector3.FORWARD):
		failures.append("Forward input did not move along camera planar forward")

	provider.output.camera_planar_forward = Vector3.RIGHT
	provider.output.camera_planar_right = Vector3.BACK
	capsule.call("update_movement", 0.016)
	var desired_rotated: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_rotated.is_equal_approx(Vector3.RIGHT):
		failures.append("Forward input did not follow changed camera planar forward")

	provider.output.camera_mode = 1
	capsule.call("update_movement", 0.016)
	var desired_action_mode: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_action_mode.is_zero_approx():
		failures.append("Action mode should remain reserved and non-behavioral")

	Input.action_release(&"move_forward")
	scene.queue_free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	Input.action_release(&"move_forward")
	if failures.is_empty():
		print("Character movement camera-relative slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
