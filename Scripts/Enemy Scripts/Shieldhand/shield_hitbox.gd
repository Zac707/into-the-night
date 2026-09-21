extends Area2D


@export var enemy: CharacterBody2D

var blocked: bool = false
var shield_available: bool = true


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack_area") and shield_available == true:
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
