extends SceneTree

const CursorPolicyScript := preload("res://systems/controls/scripts/mmo_controls_cursor_policy.gd")


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []
	var original_mouse_mode := Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var policy: Resource = CursorPolicyScript.new()
	var signal_events: Array[bool] = []
	policy.cursor_capture_changed.connect(
		func(is_captured: bool) -> void:
			signal_events.append(is_captured)
	)

	policy.apply_look_active(true)
	if policy.get_requested_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		failures.append("Active look state did not request captured mouse mode")
	if not policy.is_active():
		failures.append("Policy did not track active cursor capture state")

	policy.apply_look_active(false)
	if policy.get_requested_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		failures.append("Inactive look state did not request visible mouse mode")
	if policy.is_active():
		failures.append("Policy stayed active after look state ended")

	policy.apply_look_active(true)
	policy.force_release()
	if policy.get_requested_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		failures.append("force_release did not request restored mouse mode")
	if policy.is_active():
		failures.append("force_release did not clear active state")

	var disabled_policy: Resource = CursorPolicyScript.new()
	disabled_policy.enabled = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	disabled_policy.apply_look_active(true)
	if disabled_policy.get_requested_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		failures.append("Disabled policy requested a mouse mode change")

	if signal_events.size() < 4:
		failures.append("Cursor capture signal did not fire for active/inactive transitions")

	Input.mouse_mode = original_mouse_mode
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("MMO controls cursor policy slice validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
