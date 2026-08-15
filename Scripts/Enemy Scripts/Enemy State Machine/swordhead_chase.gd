extends StateSwordHead


class_name SwordHeadChase


var direction_switched: bool = false
var original_direction: float
var direction: float


func enter():
	original_direction = signf(enemy.player.global_position.x - enemy.global_position.x)
	enemy.last_horizontal_direction = original_direction
	
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Chase")
	else:
		enemy.animation_player.play("Left_Chase")
	
	evaluate_transitions()


func exit():
	direction_switched = false


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	if enemy.is_on_floor():
		if enemy.player != null:
			direction = signf(enemy.player.global_position.x - enemy.global_position.x)
		enemy.velocity.x += direction * enemy.move_speed * enemy.acceleration * _delta
		enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)
		if enemy.player == null:
			enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)
		if original_direction != direction:
			direction_switched = true
	else:
		enemy.last_horizontal_direction = direction


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "SwordHeadHurt")
	elif enemy.velocity.x == 0 and enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadIdle")
	elif not enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadFall")
	elif enemy.player_in_range == true and enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadAttack")
	elif direction_switched:
		transitioned_state.emit(self, "SwordHeadConfused")
