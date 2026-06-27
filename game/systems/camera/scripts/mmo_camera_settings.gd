class_name MMOCameraSettings
extends Resource

enum CameraMode {
	MMO,
	ACTION,
}

@export_range(0.1, 100.0, 0.1, "or_greater") var default_distance: float = 6.0
@export_range(0.1, 100.0, 0.1, "or_greater") var min_distance: float = 2.0
@export_range(0.1, 100.0, 0.1, "or_greater") var max_distance: float = 12.0
@export_range(-89.0, 0.0, 0.1) var min_pitch_degrees: float = -60.0
@export_range(0.0, 89.0, 0.1) var max_pitch_degrees: float = 35.0
@export_range(0.01, 5.0, 0.01, "or_greater") var rotation_sensitivity: float = 0.15
@export_range(0.01, 20.0, 0.01, "or_greater") var zoom_speed: float = 1.0
@export_range(0.0, 40.0, 0.1, "or_greater") var follow_smoothing: float = 12.0
@export_range(0.0, 40.0, 0.1, "or_greater") var rotation_smoothing: float = 18.0
@export_range(0.0, 40.0, 0.1, "or_greater") var collision_recovery_smoothing: float = 16.0
@export_range(0.0, 2.0, 0.01, "or_greater") var collision_buffer: float = 0.25
@export_range(0.0, 5.0, 0.01, "or_greater") var target_height: float = 1.5
@export var camera_mode: CameraMode = CameraMode.MMO


func get_clamped_distance(distance: float) -> float:
	return clampf(distance, min_distance, max_distance)


func get_clamped_pitch(pitch_degrees: float) -> float:
	return clampf(pitch_degrees, min_pitch_degrees, max_pitch_degrees)
