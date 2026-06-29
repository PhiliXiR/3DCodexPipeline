class_name MMOControlsCursorPolicy
extends Resource

signal cursor_capture_changed(is_captured: bool)

@export var enabled: bool = true
@export var active_mouse_mode: int = Input.MOUSE_MODE_CAPTURED
@export var inactive_mouse_mode: int = Input.MOUSE_MODE_VISIBLE
@export var restore_previous_mouse_mode: bool = true

var _previous_mouse_mode: int = Input.MOUSE_MODE_VISIBLE
var _requested_mouse_mode: int = Input.MOUSE_MODE_VISIBLE
var _is_active: bool = false


func apply_look_active(look_active: bool) -> void:
	if not enabled:
		return

	if look_active == _is_active:
		return

	if look_active:
		_previous_mouse_mode = Input.mouse_mode
		_requested_mouse_mode = active_mouse_mode
		Input.mouse_mode = _requested_mouse_mode
		_is_active = true
	else:
		_requested_mouse_mode = _previous_mouse_mode if restore_previous_mouse_mode else inactive_mouse_mode
		Input.mouse_mode = _requested_mouse_mode
		_is_active = false

	cursor_capture_changed.emit(_is_active)


func force_release() -> void:
	if not _is_active:
		return

	_requested_mouse_mode = _previous_mouse_mode if restore_previous_mouse_mode else inactive_mouse_mode
	Input.mouse_mode = _requested_mouse_mode
	_is_active = false
	cursor_capture_changed.emit(false)


func is_active() -> bool:
	return _is_active


func get_requested_mouse_mode() -> int:
	return _requested_mouse_mode
