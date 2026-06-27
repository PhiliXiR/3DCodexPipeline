class_name MMOCameraController
extends Node3D

@export var target_path: NodePath
@export var camera_path: NodePath = ^"Camera3D"
@export var settings: MMOCameraSettings
@export var initial_yaw_degrees: float = 0.0
@export var initial_pitch_degrees: float = -20.0

var _target: Node3D
var _camera: Camera3D
var _desired_yaw_degrees: float = 0.0
var _desired_pitch_degrees: float = 0.0
var _current_yaw_degrees: float = 0.0
var _current_pitch_degrees: float = 0.0
var _preferred_distance: float = 0.0
var _actual_distance: float = 0.0
var _is_initialized: bool = false
var _is_mouse_look_active: bool = false


func _ready() -> void:
	if settings == null:
		settings = MMOCameraSettings.new()

	_camera = get_node_or_null(camera_path) as Camera3D
	_target = get_node_or_null(target_path) as Node3D
	_desired_yaw_degrees = initial_yaw_degrees
	_desired_pitch_degrees = settings.get_clamped_pitch(initial_pitch_degrees)
	_current_yaw_degrees = _desired_yaw_degrees
	_current_pitch_degrees = _desired_pitch_degrees
	_preferred_distance = settings.get_clamped_distance(settings.default_distance)
	_actual_distance = _preferred_distance
	_is_initialized = true
	force_update()


func _process(delta: float) -> void:
	update_camera(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_button(event as InputEventMouseButton)
		return

	if event is InputEventMouseMotion and _is_mouse_look_active:
		_handle_mouse_motion(event as InputEventMouseMotion)


func set_target(target: Node3D) -> void:
	_target = target
	force_update()


func set_preferred_distance(distance: float) -> void:
	_preferred_distance = settings.get_clamped_distance(distance)


func orbit(yaw_delta_degrees: float, pitch_delta_degrees: float) -> void:
	_desired_yaw_degrees = wrapf(_desired_yaw_degrees + yaw_delta_degrees, -180.0, 180.0)
	_desired_pitch_degrees = settings.get_clamped_pitch(_desired_pitch_degrees + pitch_delta_degrees)


func force_update() -> void:
	if not _can_update():
		return

	_current_yaw_degrees = _desired_yaw_degrees
	_current_pitch_degrees = _desired_pitch_degrees
	_actual_distance = _preferred_distance
	_apply_transform(0.0, true)


func update_camera(delta: float) -> void:
	if not _can_update():
		return

	var rotation_weight := _get_smoothing_weight(settings.rotation_smoothing, delta)
	var distance_weight := _get_smoothing_weight(settings.collision_recovery_smoothing, delta)
	_current_yaw_degrees = lerpf(_current_yaw_degrees, _desired_yaw_degrees, rotation_weight)
	_current_pitch_degrees = lerpf(_current_pitch_degrees, _desired_pitch_degrees, rotation_weight)
	_actual_distance = lerpf(_actual_distance, _preferred_distance, distance_weight)
	_apply_transform(delta, false)


func get_yaw_degrees() -> float:
	return _desired_yaw_degrees


func get_pitch_degrees() -> float:
	return _desired_pitch_degrees


func get_preferred_distance() -> float:
	return _preferred_distance


func get_actual_distance() -> float:
	return _actual_distance


func is_mouse_look_active() -> bool:
	return _is_mouse_look_active


func get_camera_forward() -> Vector3:
	if _camera == null:
		return -global_transform.basis.z
	return -_camera.global_transform.basis.z


func get_camera_planar_forward() -> Vector3:
	var forward := get_camera_forward()
	forward.y = 0.0
	return forward.normalized() if forward.length_squared() > 0.0 else Vector3.FORWARD


func get_camera_planar_right() -> Vector3:
	var right := get_camera_planar_forward().cross(Vector3.UP)
	return right.normalized() if right.length_squared() > 0.0 else Vector3.RIGHT


func _can_update() -> bool:
	return _is_initialized and settings != null and _target != null and _camera != null


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		zoom_by_steps(1.0)
		return

	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		zoom_by_steps(-1.0)
		return

	if event.button_index == MOUSE_BUTTON_RIGHT:
		_is_mouse_look_active = event.pressed


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	var yaw_delta := -event.relative.x * settings.rotation_sensitivity
	var pitch_delta := -event.relative.y * settings.rotation_sensitivity
	orbit(yaw_delta, pitch_delta)


func zoom_by_steps(steps: float) -> void:
	set_preferred_distance(_preferred_distance - steps * settings.zoom_speed)


func _apply_transform(delta: float, snap_to_target: bool) -> void:
	var target_position := _target.global_position + Vector3.UP * settings.target_height
	if snap_to_target:
		global_position = target_position
	else:
		var follow_weight := _get_smoothing_weight(settings.follow_smoothing, delta)
		global_position = global_position.lerp(target_position, follow_weight)
	_camera.position = _get_orbit_offset(_current_yaw_degrees, _current_pitch_degrees, _actual_distance)
	_camera.look_at(target_position, Vector3.UP)


func _get_orbit_offset(yaw_degrees: float, pitch_degrees: float, distance: float) -> Vector3:
	var yaw := deg_to_rad(yaw_degrees)
	var pitch := deg_to_rad(pitch_degrees)
	var horizontal_distance := cos(pitch) * distance
	return Vector3(
		sin(yaw) * horizontal_distance,
		sin(pitch) * distance,
		cos(yaw) * horizontal_distance
	)


func _get_smoothing_weight(smoothing: float, delta: float) -> float:
	if smoothing <= 0.0:
		return 1.0
	return 1.0 - exp(-smoothing * delta)
