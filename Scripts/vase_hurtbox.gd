extends Area2D


@export var heal_orb: PackedScene


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack_area"):
		SpawnManager.place_scene(heal_orb, get_parent().global_position, Vector2(1.0, 1.0))
		get_parent().queue_free()
