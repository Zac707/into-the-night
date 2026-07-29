extends StateEnemy


class_name EnemyFall


func enter():
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	if enemy.velocity.x != 0.0:
		enemy.velocity.x += enemy.last_horizontal_direction * enemy.air_speed * enemy.acceleration * _delta
		enemy.velocity.x = clamp(enemy.velocity.x, -enemy.air_speed, enemy.air_speed)
	else:
		enemy.velocity.x = 0.0


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "EnemyHurt")
	elif enemy.is_on_floor():
		transitioned_state.emit(self, "EnemyConfused")
