extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_player_damage"):
		var attack = Attack.new()
		attack.attack_damage = 1
		attack.attack_direction = Vector2(0, 0)
		attack.knockback_force = 0.0
		area.get_player_damage(attack)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.respawn()
