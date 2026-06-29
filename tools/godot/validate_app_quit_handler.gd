extends SceneTree

const QuitHandlerScript := preload("res://autoload/app_quit_handler.gd")


func _initialize() -> void:
	call_deferred("_run_validation")


func _run_validation() -> void:
	var failures: Array[String] = []

	var autoload_path: String = ProjectSettings.get_setting("autoload/AppQuitHandler", "") as String
	if autoload_path != "*res://autoload/app_quit_handler.gd":
		failures.append("AppQuitHandler autoload is not registered")

	if not InputMap.has_action(&"quit_game"):
		failures.append("quit_game input action is not registered")

	var quit_handler: Node = QuitHandlerScript.new()
	var escape_event := InputEventKey.new()
	escape_event.keycode = KEY_ESCAPE
	escape_event.pressed = true
	if not quit_handler.should_quit_for_event(escape_event):
		failures.append("Escape key press did not request quit")

	var escape_echo_event := InputEventKey.new()
	escape_echo_event.keycode = KEY_ESCAPE
	escape_echo_event.pressed = true
	escape_echo_event.echo = true
	if quit_handler.should_quit_for_event(escape_echo_event):
		failures.append("Escape key echo should not request quit")

	var other_event := InputEventKey.new()
	other_event.keycode = KEY_A
	other_event.pressed = true
	if quit_handler.should_quit_for_event(other_event):
		failures.append("Non-Escape key unexpectedly requested quit")

	quit_handler.free()
	_finish(failures)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("App quit handler validation passed.")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)
