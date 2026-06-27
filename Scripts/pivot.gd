extends Node2D


var rotation_permitted: bool = true


func _on_player_new_direction(rotation_angle) -> void:
	if rotation_angle != 90 and rotation_permitted == true:
		self.rotation = deg_to_rad(rotation_angle)
