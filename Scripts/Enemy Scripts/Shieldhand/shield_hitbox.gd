extends Area2D


@export var enemy: CharacterBody2D

var blocked: bool = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack_area"):
		blocked = true
		enemy.defended = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("attack_area"):
		blocked = false



func get_defense() -> bool:
	if blocked == true:
		blocked = false
		return true
	else:
		blocked = false
		return false
