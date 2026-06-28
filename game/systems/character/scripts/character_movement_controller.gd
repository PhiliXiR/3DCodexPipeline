class_name CharacterMovementController
extends CharacterBody3D

signal movement_started
signal movement_stopped
signal grounded_state_changed(is_grounded: bool)

const CharacterMovementSettingsScript := preload("res://systems/character/scripts/character_movement_settings.gd")

@export var settings: Resource
@export var visual_root_path: NodePath

var _movement_enabled: bool = true
var _desired_movement_direction: Vector3 = Vector3.ZERO
var _last_nonzero_movement_direction: Vector3 = Vector3.FORWARD
var _external_movement_vector: Vector3 = Vector3.ZERO
var _has_external_movement_vector: bool = false
var _was_moving: bool = false
var _was_grounded: bool = false


func _ready() -> void:
	if settings == null:
		settings = CharacterMovementSettingsScript.new()
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


func update_movement(delta: float) -> void:
	if settings == null:
		settings = CharacterMovementSettingsScript.new()

	_desired_movement_direction = _get_requested_movement_direction()
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


func is_moving() -> bool:
	return Vector2(velocity.x, velocity.z).length_squared() > 0.0001


func is_grounded() -> bool:
	return is_on_floor()


func _get_requested_movement_direction() -> Vector3:
	if not _movement_enabled:
		return Vector3.ZERO

	if not _has_external_movement_vector:
		return Vector3.ZERO

	var requested := Vector3(_external_movement_vector.x, 0.0, _external_movement_vector.z)
	if requested.length_squared() <= 0.0001:
		return Vector3.ZERO

	var normalized := requested.normalized()
	_last_nonzero_movement_direction = normalized
	return normalized


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
