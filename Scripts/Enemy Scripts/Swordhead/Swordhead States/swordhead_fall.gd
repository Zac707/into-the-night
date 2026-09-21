extends StateSwordHead


class_name SwordHeadFall


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Fall")
	else:
		enemy.animation_player.play("Left_Fall")
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	if enemy.velocity.x != 0.0:
		enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "SwordHeadHurt")
	elif enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadConfused")
