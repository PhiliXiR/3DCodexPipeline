extends SceneTree

class FakeCameraOutput:
	extends Resource

	var camera_mode: int = 0
	var camera_planar_forward: Vector3 = Vector3.FORWARD
	var camera_planar_right: Vector3 = Vector3.RIGHT
	var should_face_camera: bool = false
	var desired_character_facing_direction: Vector3 = Vector3.ZERO


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

	var initial_right_alignment := _facing_direction(capsule).dot(Vector3.RIGHT)
	Input.action_press(&"move_right")
	capsule.call("update_movement", 0.016)
	var first_step_alignment := _facing_direction(capsule).dot(Vector3.RIGHT)
	if first_step_alignment <= initial_right_alignment:
		failures.append("Capsule did not begin turning toward movement direction")
	if first_step_alignment >= 0.98:
		failures.append("Capsule snapped instantly to movement direction")

	for index in range(20):
		capsule.call("update_movement", 0.016)

	var later_alignment := _facing_direction(capsule).dot(Vector3.RIGHT)
	if later_alignment <= first_step_alignment:
		failures.append("Capsule did not continue turning toward movement direction")

	Input.action_release(&"move_right")
	capsule.rotation.y = deg_to_rad(-90.0)
	provider.output.should_face_camera = true
	provider.output.desired_character_facing_direction = Vector3.FORWARD
	Input.action_press(&"move_right")
	capsule.call("update_movement", 0.016)
	var camera_facing_alignment := _facing_direction(capsule).dot(Vector3.FORWARD)
	if camera_facing_alignment <= 0.0:
		failures.append("RMB camera-facing intent did not rotate toward camera planar forward")
	var desired_movement: Vector3 = capsule.call("get_desired_movement_direction") as Vector3
	if not desired_movement.is_equal_approx(Vector3.RIGHT):
		failures.append("RMB camera-facing intent changed movement direction ownership")

	Input.action_release(&"move_right")
	provider.output.should_face_camera = false
	provider.output.desired_character_facing_direction = Vector3.ZERO
	provider.output.camera_mode = 1
	var yaw_before_action_mode := capsule.rotation.y
	capsule.call("update_movement", 0.016)
	if not is_equal_approx(capsule.rotation.y, yaw_before_action_mode):
		failures.append("Action mode changed facing despite being reserved")

	Input.action_release(&"move_right")
	scene.queue_free()
	_finish(failures)


func _facing_direction(node: Node3D) -> Vector3:
	var forward := -node.global_transform.basis.z
	forward.y = 0.0
	return forward.normalized()


func _finish(failures: Array[String]) -> void:
	Input.action_release(&"move_right")
	if failures.is_empty():
		print("Character movement facing slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
