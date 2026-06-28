class_name MMOCameraExtensionHooks
extends Resource

var target_lock_provider: Node
var camera_shake_provider: Node
var camera_zone_provider: Node


func configure(target_lock: Node, camera_shake: Node, camera_zone: Node) -> void:
	target_lock_provider = target_lock
	camera_shake_provider = camera_shake
	camera_zone_provider = camera_zone


func has_target_lock_provider() -> bool:
	return target_lock_provider != null


func has_camera_shake_provider() -> bool:
	return camera_shake_provider != null


func has_camera_zone_provider() -> bool:
	return camera_zone_provider != null
