extends StateSwordHead


class_name SwordHeadConfused


var confused_time: float = 1.2


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Confused")
	else:
		enemy.animation_player.play("Left_Confused")
	
	enemy.effect_player.play("question_mark")
	
	evaluate_transitions()


func exit():
	confused_time = 1.2
	enemy.effect_player.play("effects_disabled")


func update(_delta: float):
	confused_time -= _delta 
	
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "SwordHeadHurt")
	elif not enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadFall")
	elif enemy.player != null and enemy.player_in_range and confused_time <= 0.0:
		transitioned_state.emit(self, "SwordHeadAttack")
	elif enemy.player != null and confused_time <= 0.0:
		transitioned_state.emit(self, "SwordHeadChase")
	elif enemy.player == null and confused_time <= 0.0:
		transitioned_state.emit(self, "SwordHeadIdle")
