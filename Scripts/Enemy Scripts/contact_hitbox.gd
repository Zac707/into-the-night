extends Area2D


@export var enemy: CharacterBody2D


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_player_damage"):
		var attack = Attack.new()
		attack.attack_damage = 1
		attack.attack_direction = Vector2(enemy.last_horizontal_direction, 0.0)
		attack.knockback_force = 100
		area.get_player_damage(attack)
