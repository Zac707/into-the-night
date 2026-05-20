extends Node2D


func _on_character_body_2d_last_direction_pressed(rotation_angle) -> void:
	self.rotation = deg_to_rad(rotation_angle)
