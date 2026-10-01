extends Area2D


@export var enemy: CharacterBody2D

var shield_available: bool = true


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack_area") and shield_available == true and enemy.defenseless == false:
		enemy.defended = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("attack_area"):
		enemy.defended = false


func on_hooked() -> void:
	enemy.hooked = true
