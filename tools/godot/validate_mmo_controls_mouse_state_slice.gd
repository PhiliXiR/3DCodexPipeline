extends SceneTree

const MouseStateScript := preload("res://systems/controls/scripts/mmo_controls_mouse_state.gd")
const STATE_NONE := 0
const STATE_LEFT_ONLY := 1
const STATE_RIGHT_ONLY := 2
const STATE_BOTH := 3


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []
	var mouse_state: Resource = MouseStateScript.new()
	var signal_events: Array[Vector2i] = []
	mouse_state.mouse_button_state_changed.connect(
		func(left_pressed: bool, right_pressed: bool) -> void:
			signal_events.append(Vector2i(1 if left_pressed else 0, 1 if right_pressed else 0))
	)

	if mouse_state.get_mouse_button_state() != STATE_NONE:
		failures.append("Initial mouse button state was not NONE")
	if mouse_state.should_orbit_camera():
		failures.append("Initial state unexpectedly requested camera orbit")
	if mouse_state.should_move_forward_from_mouse():
		failures.append("Initial state unexpectedly requested mouse forward movement")

	var left_press := InputEventMouseButton.new()
	left_press.button_index = MOUSE_BUTTON_LEFT
	left_press.pressed = true
	if not mouse_state.handle_input_event(left_press):
		failures.append("Left mouse event was not consumed")
	if mouse_state.get_mouse_button_state() != STATE_LEFT_ONLY:
		failures.append("Left mouse press did not produce LEFT_ONLY state")
	if not mouse_state.is_left_mouse_pressed():
		failures.append("Left mouse press was not tracked separately")
	if mouse_state.is_right_mouse_pressed():
		failures.append("Left mouse press incorrectly set right mouse state")
	if not mouse_state.is_left_mouse_look_active():
		failures.append("Left-only state did not expose left mouse look")
	if not mouse_state.should_orbit_camera():
		failures.append("Left-only state did not expose camera orbit intent")
	if mouse_state.should_face_camera_direction():
		failures.append("Left-only state incorrectly exposed character-facing intent")
	if mouse_state.should_move_forward_from_mouse():
		failures.append("Left-only state incorrectly exposed mouse forward movement")

	var right_press := InputEventMouseButton.new()
	right_press.button_index = MOUSE_BUTTON_RIGHT
	right_press.pressed = true
	mouse_state.handle_input_event(right_press)
	if mouse_state.get_mouse_button_state() != STATE_BOTH:
		failures.append("Combined mouse press did not produce BOTH state")
	if not mouse_state.is_both_mouse_buttons_active():
		failures.append("Both-buttons state was not tracked")
	if not mouse_state.should_orbit_camera():
		failures.append("Both-buttons state did not expose camera orbit intent")
	if not mouse_state.should_face_camera_direction():
		failures.append("Both-buttons state did not expose character-facing intent")
	if not mouse_state.should_move_forward_from_mouse():
		failures.append("Both-buttons state did not expose mouse forward movement intent")

	var left_release := InputEventMouseButton.new()
	left_release.button_index = MOUSE_BUTTON_LEFT
	left_release.pressed = false
	mouse_state.handle_input_event(left_release)
	if mouse_state.get_mouse_button_state() != STATE_RIGHT_ONLY:
		failures.append("Releasing left mouse did not leave RIGHT_ONLY state")
	if not mouse_state.is_right_mouse_pressed():
		failures.append("Right mouse state was not tracked separately")
	if not mouse_state.is_right_mouse_look_active():
		failures.append("Right-only state did not expose right mouse look")
	if not mouse_state.should_face_camera_direction():
		failures.append("Right-only state did not expose character-facing intent")
	if mouse_state.should_move_forward_from_mouse():
		failures.append("Right-only state incorrectly exposed mouse forward movement")

	var wheel_event := InputEventMouseButton.new()
	wheel_event.button_index = MOUSE_BUTTON_WHEEL_UP
	wheel_event.pressed = true
	if mouse_state.handle_input_event(wheel_event):
		failures.append("Wheel event should not be consumed by mouse look state")

	mouse_state.release_all()
	if mouse_state.get_mouse_button_state() != STATE_NONE:
		failures.append("release_all did not return to NONE state")
	if signal_events.size() < 4:
		failures.append("Mouse button state change signal did not fire for state transitions")

	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO controls mouse state slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
