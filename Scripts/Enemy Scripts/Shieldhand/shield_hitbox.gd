extends Area2D


@export var enemy: CharacterBody2D

var blocked: bool = false
var shield_available: bool = true


func _on_area_entered(area: Area2D) -> void:
	print(shield_available, " ", enemy.defenseless, " ", area)
	if area.is_in_group("attack_area") and shield_available == true and enemy.defenseless == false:
		blocked = true
		enemy.defended = true


func _on_area_exited(area: Area2D) -> void:
	print("SHIELD exited   frame=", Engine.get_physics_frames(), " ", area)
	if area.is_in_group("attack_area"):
		blocked = false
		enemy.defended = false


func get_defense() -> bool:
	print("get_defense     blocked=", blocked)
	if blocked == true:
		return true
	else:
		return false
