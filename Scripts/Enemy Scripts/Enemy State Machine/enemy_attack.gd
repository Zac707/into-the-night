extends StateEnemy


class_name EnemyAttack


var attack_complete: bool = false


func enter():
	pass


func exit():
	attack_complete = false


func update(_delta: float):
	for area in enemy.attack_component.get_overlapping_areas():
		if area.has_method("get_player_damage"):
			var attack = Attack.new()
			attack.attack_damage = 1
			attack.attack_direction = Vector2(enemy.last_horizontal_direction, 0.0)
			attack.knockback_force = 30
			area.get_player_damage(attack)
	
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x += enemy.last_horizontal_direction * enemy.attack_speed * enemy.acceleration * _delta
	enemy.velocity.x = clamp(enemy.velocity.x, -enemy.attack_speed, enemy.attack_speed)


func evaluate_transitions():
	if attack_complete and enemy.is_on_floor():
		transitioned_state.emit(self, "EnemyConfused")
	elif attack_complete:
		transitioned_state.emit(self, "EnemyFall")


func on_attack_finished():
	attack_complete = true
