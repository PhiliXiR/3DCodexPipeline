class_name CharacterMovementSettings
extends Resource

enum LateralInputMode {
	STRAFE,
	TURN,
}

@export_range(0.1, 50.0, 0.1, "or_greater") var move_speed: float = 6.0
@export_range(0.1, 100.0, 0.1, "or_greater") var acceleration: float = 24.0
@export_range(0.1, 100.0, 0.1, "or_greater") var deceleration: float = 28.0
@export_range(0.0, 100.0, 0.1, "or_greater") var gravity: float = 24.0
@export_range(0.0, 200.0, 0.1, "or_greater") var max_fall_speed: float = 60.0
@export_range(0.1, 40.0, 0.1, "or_greater") var turn_speed: float = 12.0
@export_range(0.1, 720.0, 0.1, "or_greater") var keyboard_turn_speed_degrees: float = 160.0
@export var lateral_input_mode: LateralInputMode = LateralInputMode.STRAFE
@export var move_forward_action: StringName = &"move_forward"
@export var move_backward_action: StringName = &"move_backward"
@export var move_left_action: StringName = &"move_left"
@export var move_right_action: StringName = &"move_right"
