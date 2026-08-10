extends StateEnemy


class_name EnemyIdle


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Idle")
	else:
		enemy.animation_player.play("Left_Idle")
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "EnemyHurt")
	elif enemy.player != null:
		transitioned_state.emit(self, "EnemyChase")
