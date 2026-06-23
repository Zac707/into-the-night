extends Area2D


@export var camera_bounds: Node2D

signal new_camera_boundaries


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		new_camera_boundaries.emit(camera_bounds)
