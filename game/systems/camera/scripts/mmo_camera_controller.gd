class_name MMOCameraController
extends Node3D

signal camera_mode_changed(camera_mode: int)

const MMOCameraExtensionHooksScript := preload("res://systems/camera/scripts/mmo_camera_extension_hooks.gd")
const MMOControlsCursorPolicyScript := preload("res://systems/controls/scripts/mmo_controls_cursor_policy.gd")
const MMOControlsMouseStateScript := preload("res://systems/controls/scripts/mmo_controls_mouse_state.gd")

@export var target_path: NodePath
@export var camera_path: NodePath = ^"Camera3D"
@export var settings: MMOCameraSettings
@export var initial_yaw_degrees: float = 0.0
@export var initial_pitch_degrees: float = -20.0
@export_group("Extension Hooks")
@export var target_lock_provider_path: NodePath
@export var camera_shake_provider_path: NodePath
@export var camera_zone_provider_path: NodePath

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
var _mode_output: MMOCameraModeOutput = MMOCameraModeOutput.new()
var _extension_hooks: Resource = MMOCameraExtensionHooksScript.new()
var _controls_mouse_state: Resource = MMOControlsMouseStateScript.new()
var _cursor_policy: Resource = MMOControlsCursorPolicyScript.new()


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
	_resolve_extension_hooks()
	_controls_mouse_state.mouse_button_state_changed.connect(_on_controls_mouse_state_changed)
	_is_initialized = true
	force_update()


func _exit_tree() -> void:
	_cursor_policy.force_release()


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


func set_camera_mode(camera_mode: int) -> void:
	if settings == null:
		settings = MMOCameraSettings.new()

	if settings.camera_mode == camera_mode:
		return

	settings.camera_mode = camera_mode
	_update_mode_output()
	camera_mode_changed.emit(camera_mode)


func get_camera_mode() -> int:
	if settings == null:
		return MMOCameraSettings.CameraMode.MMO
	return settings.camera_mode


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
	_current_yaw_degrees = _lerp_angle_degrees(_current_yaw_degrees, _desired_yaw_degrees, rotation_weight)
	_current_pitch_degrees = lerpf(_current_pitch_degrees, _desired_pitch_degrees, rotation_weight)
	_actual_distance = lerpf(_actual_distance, _preferred_distance, distance_weight)
	_apply_transform(delta, false)


func get_yaw_degrees() -> float:
	return _desired_yaw_degrees


func get_current_yaw_degrees() -> float:
	return _current_yaw_degrees


func get_pitch_degrees() -> float:
	return _desired_pitch_degrees


func get_preferred_distance() -> float:
	return _preferred_distance


func get_actual_distance() -> float:
	return _actual_distance


func is_mouse_look_active() -> bool:
	return _is_mouse_look_active


func get_controls_mouse_state() -> Resource:
	return _controls_mouse_state


func get_cursor_policy() -> Resource:
	return _cursor_policy


func set_cursor_policy(cursor_policy: Resource) -> void:
	if cursor_policy == null:
		_cursor_policy = MMOControlsCursorPolicyScript.new()
	else:
		_cursor_policy = cursor_policy
	_cursor_policy.apply_look_active(_controls_mouse_state.should_orbit_camera())


func get_mouse_button_state() -> int:
	return _controls_mouse_state.get_mouse_button_state()


func is_left_mouse_look_active() -> bool:
	return _controls_mouse_state.is_left_mouse_look_active()


func is_right_mouse_look_active() -> bool:
	return _controls_mouse_state.is_right_mouse_look_active()


func is_both_mouse_move_active() -> bool:
	return _controls_mouse_state.should_move_forward_from_mouse()


func should_face_camera_direction() -> bool:
	return _controls_mouse_state.should_face_camera_direction()


func should_move_forward_from_mouse() -> bool:
	return _controls_mouse_state.should_move_forward_from_mouse()


func get_mode_output() -> MMOCameraModeOutput:
	_update_mode_output()
	return _mode_output


func configure_extension_hooks(target_lock_provider: Node, camera_shake_provider: Node, camera_zone_provider: Node) -> void:
	_extension_hooks.configure(target_lock_provider, camera_shake_provider, camera_zone_provider)


func get_extension_hooks() -> Resource:
	return _extension_hooks


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


func _resolve_extension_hooks() -> void:
	_extension_hooks.configure(
		_get_optional_node(target_lock_provider_path),
		_get_optional_node(camera_shake_provider_path),
		_get_optional_node(camera_zone_provider_path)
	)


func _get_optional_node(path: NodePath) -> Node:
	if path.is_empty():
		return null
	return get_node_or_null(path)


func _handle_mouse_button(event: InputEventMouseButton) -> void:
	if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		zoom_by_steps(1.0)
		return

	if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		zoom_by_steps(-1.0)
		return

	if _controls_mouse_state.handle_input_event(event):
		_is_mouse_look_active = _controls_mouse_state.should_orbit_camera()


func _handle_mouse_motion(event: InputEventMouseMotion) -> void:
	var yaw_delta := -event.relative.x * settings.rotation_sensitivity
	var pitch_delta := event.relative.y * settings.rotation_sensitivity
	orbit(yaw_delta, pitch_delta)


func _on_controls_mouse_state_changed(_left_pressed: bool, _right_pressed: bool) -> void:
	_is_mouse_look_active = _controls_mouse_state.should_orbit_camera()
	_cursor_policy.apply_look_active(_is_mouse_look_active)


func zoom_by_steps(steps: float) -> void:
	set_preferred_distance(_preferred_distance - steps * settings.zoom_speed)


func _apply_transform(delta: float, snap_to_target: bool) -> void:
	var target_position := _target.global_position + Vector3.UP * settings.target_height
	if snap_to_target:
		global_position = target_position
	else:
		var follow_weight := _get_smoothing_weight(settings.follow_smoothing, delta)
		global_position = global_position.lerp(target_position, follow_weight)

	var desired_offset := _get_orbit_offset(_current_yaw_degrees, _current_pitch_degrees, _actual_distance)
	_actual_distance = _get_collision_limited_distance(target_position, desired_offset)
	_camera.position = _get_orbit_offset(_current_yaw_degrees, _current_pitch_degrees, _actual_distance)
	_camera.look_at(target_position, Vector3.UP)
	_update_mode_output()


func _update_mode_output() -> void:
	_mode_output.update_from_camera(
		get_camera_mode(),
		get_camera_forward(),
		get_camera_planar_forward(),
		get_camera_planar_right(),
		_is_mouse_look_active,
		_controls_mouse_state.should_face_camera_direction()
	)


func _get_collision_limited_distance(target_position: Vector3, desired_offset: Vector3) -> float:
	if not settings.collision_enabled:
		return _actual_distance

	var desired_distance := desired_offset.length()
	if desired_distance <= 0.0:
		return desired_distance

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		target_position,
		global_position + desired_offset,
		settings.collision_mask,
		_get_collision_exclusions()
	)
	query.hit_from_inside = true
	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		return desired_distance

	var hit_position: Vector3 = hit["position"]
	var limited_distance := target_position.distance_to(hit_position) - settings.collision_buffer
	return clampf(limited_distance, 0.05, desired_distance)


func _get_collision_exclusions() -> Array[RID]:
	var exclusions: Array[RID] = []
	if _target is CollisionObject3D:
		exclusions.append((_target as CollisionObject3D).get_rid())
	return exclusions


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


func _lerp_angle_degrees(from_degrees: float, to_degrees: float, weight: float) -> float:
	return rad_to_deg(lerp_angle(deg_to_rad(from_degrees), deg_to_rad(to_degrees), weight))
