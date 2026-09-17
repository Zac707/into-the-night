extends Area2D


@export var enemy: CharacterBody2D


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack_area"):
		enemy.defended == true
