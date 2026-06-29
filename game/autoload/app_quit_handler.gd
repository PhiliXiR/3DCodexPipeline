extends Node

@export var quit_action: StringName = &"quit_game"


func _unhandled_input(event: InputEvent) -> void:
	if should_quit_for_event(event):
		get_viewport().set_input_as_handled()
		get_tree().quit()


func should_quit_for_event(event: InputEvent) -> bool:
	if event == null:
		return false

	if event.is_action_pressed(quit_action):
		return true

	if not event is InputEventKey:
		return false

	var key_event := event as InputEventKey
	return key_event.pressed and not key_event.echo and key_event.keycode == KEY_ESCAPE
