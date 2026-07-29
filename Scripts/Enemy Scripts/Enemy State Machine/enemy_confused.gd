extends StateEnemy


class_name EnemyIdle


func enter():
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
