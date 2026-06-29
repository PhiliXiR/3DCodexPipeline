class_name MMOCameraModeOutput
extends Resource

var camera_mode: int = MMOCameraSettings.CameraMode.MMO
var camera_forward: Vector3 = Vector3.FORWARD
var camera_planar_forward: Vector3 = Vector3.FORWARD
var camera_planar_right: Vector3 = Vector3.RIGHT
var desired_character_facing_direction: Vector3 = Vector3.ZERO
var should_face_camera: bool = false
var is_mouse_look_active: bool = false


func update_from_camera(
	mode: int,
	forward: Vector3,
	planar_forward: Vector3,
	planar_right: Vector3,
	mouse_look_active: bool,
	controls_should_face_camera: bool = false
) -> void:
	camera_mode = mode
	camera_forward = forward
	camera_planar_forward = planar_forward
	camera_planar_right = planar_right
	is_mouse_look_active = mouse_look_active
	should_face_camera = camera_mode == MMOCameraSettings.CameraMode.ACTION or controls_should_face_camera
	desired_character_facing_direction = camera_planar_forward if should_face_camera else Vector3.ZERO
