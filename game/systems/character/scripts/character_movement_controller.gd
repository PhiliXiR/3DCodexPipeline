class_name CharacterMovementController
extends CharacterBody3D

signal movement_started
signal movement_stopped
signal grounded_state_changed(is_grounded: bool)

const CharacterMovementSettingsScript := preload("res://systems/character/scripts/character_movement_settings.gd")

@export var settings: Resource
@export var visual_root_path: NodePath
@export var camera_output_provider_path: NodePath

var _movement_enabled: bool = true
var _desired_movement_direction: Vector3 = Vector3.ZERO
var _last_nonzero_movement_direction: Vector3 = Vector3.FORWARD
var _external_movement_vector: Vector3 = Vector3.ZERO
var _has_external_movement_vector: bool = false
var _turn_input_axis: float = 0.0
var _camera_output_provider: Node
var _was_moving: bool = false
var _was_grounded: bool = false


func _ready() -> void:
	if settings == null:
		settings = CharacterMovementSettingsScript.new()
	_camera_output_provider = _get_optional_node(camera_output_provider_path)
	_was_grounded = is_on_floor()


func _physics_process(delta: float) -> void:
	update_movement(delta)


func set_movement_enabled(enabled: bool) -> void:
	_movement_enabled = enabled
	if not _movement_enabled:
		_desired_movement_direction = Vector3.ZERO


func set_external_movement_vector(vector: Vector3) -> void:
	_external_movement_vector = vector
	_has_external_movement_vector = true


func clear_external_movement_vector() -> void:
	_external_movement_vector = Vector3.ZERO
	_has_external_movement_vector = false


func set_camera_output_provider(provider: Node) -> void:
	_camera_output_provider = provider


func update_movement(delta: float) -> void:
	if settings == null:
		settings = CharacterMovementSettingsScript.new()

	_desired_movement_direction = _get_requested_movement_direction()
	_apply_keyboard_turn_input(delta)
	_apply_facing(delta)
	_apply_horizontal_velocity(delta)
	_apply_gravity(delta)
	move_and_slide()
	_update_state_signals()


func get_desired_movement_direction() -> Vector3:
	return _desired_movement_direction


func get_current_velocity() -> Vector3:
	return velocity


func get_last_nonzero_movement_direction() -> Vector3:
	return _last_nonzero_movement_direction


func get_turn_input_axis() -> float:
	return _turn_input_axis


func is_moving() -> bool:
	return Vector2(velocity.x, velocity.z).length_squared() > 0.0001


func is_grounded() -> bool:
	return is_on_floor()


func _get_requested_movement_direction() -> Vector3:
	if not _movement_enabled:
		return Vector3.ZERO

	if _has_external_movement_vector:
		return _get_normalized_movement_direction(_external_movement_vector)

	return _get_input_movement_direction()


func _get_normalized_movement_direction(direction: Vector3) -> Vector3:
	var requested := Vector3(direction.x, 0.0, direction.z)
	if requested.length_squared() <= 0.0001:
		return Vector3.ZERO

	var normalized := requested.normalized()
	_last_nonzero_movement_direction = normalized
	return normalized


func _get_input_movement_direction() -> Vector3:
	var forward_strength := _get_action_strength(settings.get("move_forward_action") as StringName)
	var backward_strength := _get_action_strength(settings.get("move_backward_action") as StringName)
	var left_strength := _get_action_strength(settings.get("move_left_action") as StringName)
	var right_strength := _get_action_strength(settings.get("move_right_action") as StringName)
	var lateral_axis := right_strength - left_strength
	_turn_input_axis = 0.0
	if settings.get("lateral_input_mode") as int == CharacterMovementSettingsScript.LateralInputMode.TURN:
		_turn_input_axis = lateral_axis
		lateral_axis = 0.0

	var input_vector := Vector2(lateral_axis, forward_strength - backward_strength)
	if input_vector.length_squared() <= 0.0001:
		return Vector3.ZERO

	input_vector = input_vector.limit_length(1.0)
	var camera_forward := _get_camera_planar_forward()
	var camera_right := _get_camera_planar_right()
	return _get_normalized_movement_direction(
		camera_forward * input_vector.y + camera_right * input_vector.x
	)


func _get_action_strength(action_name: StringName) -> float:
	if not InputMap.has_action(action_name):
		return 0.0
	return Input.get_action_strength(action_name)


func _get_camera_planar_forward() -> Vector3:
	var output := _get_camera_mode_output()
	if output == null:
		return Vector3.FORWARD

	var camera_mode: int = output.get("camera_mode") as int
	if camera_mode != 0:
		return Vector3.ZERO

	var forward: Vector3 = output.get("camera_planar_forward") as Vector3
	return forward.normalized() if forward.length_squared() > 0.0001 else Vector3.FORWARD


func _get_camera_planar_right() -> Vector3:
	var output := _get_camera_mode_output()
	if output == null:
		return Vector3.RIGHT

	var camera_mode: int = output.get("camera_mode") as int
	if camera_mode != 0:
		return Vector3.ZERO

	var right: Vector3 = output.get("camera_planar_right") as Vector3
	return right.normalized() if right.length_squared() > 0.0001 else Vector3.RIGHT


func _get_camera_mode_output() -> Resource:
	if _camera_output_provider == null or not _camera_output_provider.has_method("get_mode_output"):
		return null
	return _camera_output_provider.call("get_mode_output") as Resource


func _get_optional_node(path: NodePath) -> Node:
	if path.is_empty():
		return null
	return get_node_or_null(path)


func _apply_facing(delta: float) -> void:
	var facing_direction := _get_requested_facing_direction()
	if facing_direction.length_squared() <= 0.0001:
		return

	var target_yaw := atan2(-facing_direction.x, -facing_direction.z)
	var turn_speed: float = settings.get("turn_speed") as float
	var weight := _get_smoothing_weight(turn_speed, delta)
	rotation.y = rotation.y + angle_difference(rotation.y, target_yaw) * weight


func _get_requested_facing_direction() -> Vector3:
	if _desired_movement_direction.length_squared() <= 0.0001:
		return Vector3.ZERO

	var camera_facing_direction := _get_camera_requested_facing_direction()
	if camera_facing_direction.length_squared() > 0.0001:
		return camera_facing_direction

	return _desired_movement_direction


func _get_camera_requested_facing_direction() -> Vector3:
	var output := _get_camera_mode_output()
	if output == null:
		return Vector3.ZERO

	var should_face_camera_variant: Variant = output.get("should_face_camera")
	if not should_face_camera_variant is bool or not should_face_camera_variant:
		return Vector3.ZERO

	var facing_direction: Vector3 = output.get("desired_character_facing_direction") as Vector3
	facing_direction.y = 0.0
	return facing_direction.normalized() if facing_direction.length_squared() > 0.0001 else Vector3.ZERO


func _apply_keyboard_turn_input(delta: float) -> void:
	if absf(_turn_input_axis) <= 0.0001:
		return

	var camera_mode_output := _get_camera_mode_output()
	if camera_mode_output != null and camera_mode_output.get("camera_mode") as int != 0:
		return

	var keyboard_turn_speed: float = settings.get("keyboard_turn_speed_degrees") as float
	rotation.y -= deg_to_rad(keyboard_turn_speed) * _turn_input_axis * delta


func _apply_horizontal_velocity(delta: float) -> void:
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	var target_velocity: Vector3 = _desired_movement_direction * (settings.get("move_speed") as float)
	var rate: float = settings.get("acceleration") as float
	if _desired_movement_direction.length_squared() <= 0.0:
		rate = settings.get("deceleration") as float
	var weight := _get_smoothing_weight(rate, delta)
	var smoothed_velocity := horizontal_velocity.lerp(target_velocity, weight)
	velocity.x = smoothed_velocity.x
	velocity.z = smoothed_velocity.z


func _apply_gravity(delta: float) -> void:
	if is_on_floor() and velocity.y < 0.0:
		velocity.y = 0.0
		return

	var gravity: float = settings.get("gravity") as float
	var max_fall_speed: float = settings.get("max_fall_speed") as float
	velocity.y = maxf(velocity.y - gravity * delta, -max_fall_speed)


func _update_state_signals() -> void:
	var moving := is_moving()
	if moving != _was_moving:
		if moving:
			movement_started.emit()
		else:
			movement_stopped.emit()
		_was_moving = moving

	var grounded := is_on_floor()
	if grounded != _was_grounded:
		grounded_state_changed.emit(grounded)
		_was_grounded = grounded


func _get_smoothing_weight(rate: float, delta: float) -> float:
	if rate <= 0.0:
		return 1.0
	return 1.0 - exp(-rate * delta)
