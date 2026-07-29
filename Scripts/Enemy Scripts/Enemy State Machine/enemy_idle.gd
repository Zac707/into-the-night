extends StateEnemy


class_name EnemyConfused


var confused_time: float = 1.5


func enter():
	evaluate_transitions()


func exit():
	confused_time = 1.5


func update(_delta: float):
	confused_time -= _delta 
	
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "EnemyHurt")
	elif not enemy.is_on_floor():
		transitioned_state.emit(self, "EnemyFall")
	elif enemy.player != null and enemy.player_in_range and confused_time <= 0.0:
		transitioned_state.emit(self, "EnemyAttack")
	elif enemy.player != null and confused_time <= 0.0:
		transitioned_state.emit(self, "EnemyChase")
	elif enemy.player == null and confused_time <= 0.0:
		transitioned_state.emit(self, "EnemyIdle")
