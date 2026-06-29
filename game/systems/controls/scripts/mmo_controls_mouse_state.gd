class_name MMOControlsMouseState
extends Resource

signal mouse_button_state_changed(left_pressed: bool, right_pressed: bool)

enum MouseButtonState {
	NONE,
	LEFT_ONLY,
	RIGHT_ONLY,
	BOTH,
}

var _left_pressed: bool = false
var _right_pressed: bool = false


func handle_input_event(event: InputEvent) -> bool:
	if not event is InputEventMouseButton:
		return false

	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index == MOUSE_BUTTON_LEFT:
		set_left_mouse_pressed(mouse_event.pressed)
		return true

	if mouse_event.button_index == MOUSE_BUTTON_RIGHT:
		set_right_mouse_pressed(mouse_event.pressed)
		return true

	return false


func set_left_mouse_pressed(pressed: bool) -> void:
	if _left_pressed == pressed:
		return

	_left_pressed = pressed
	mouse_button_state_changed.emit(_left_pressed, _right_pressed)


func set_right_mouse_pressed(pressed: bool) -> void:
	if _right_pressed == pressed:
		return

	_right_pressed = pressed
	mouse_button_state_changed.emit(_left_pressed, _right_pressed)


func release_all() -> void:
	var changed := _left_pressed or _right_pressed
	_left_pressed = false
	_right_pressed = false
	if changed:
		mouse_button_state_changed.emit(_left_pressed, _right_pressed)


func is_left_mouse_pressed() -> bool:
	return _left_pressed


func is_right_mouse_pressed() -> bool:
	return _right_pressed


func get_mouse_button_state() -> MouseButtonState:
	if _left_pressed and _right_pressed:
		return MouseButtonState.BOTH
	if _left_pressed:
		return MouseButtonState.LEFT_ONLY
	if _right_pressed:
		return MouseButtonState.RIGHT_ONLY
	return MouseButtonState.NONE


func is_left_mouse_look_active() -> bool:
	return _left_pressed and not _right_pressed


func is_right_mouse_look_active() -> bool:
	return _right_pressed and not _left_pressed


func is_both_mouse_buttons_active() -> bool:
	return _left_pressed and _right_pressed


func should_orbit_camera() -> bool:
	return _left_pressed or _right_pressed


func should_face_camera_direction() -> bool:
	return _right_pressed


func should_move_forward_from_mouse() -> bool:
	return _left_pressed and _right_pressed
