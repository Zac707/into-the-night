extends Node2D


func _on_player_new_direction(rotation_angle) -> void:
	self.rotation = deg_to_rad(rotation_angle)
