# Script will only be called when shield is still present.
extends StateShieldHand


class_name ShieldHandApproach


var original_direction: float
var direction: float
var distance_to_player: Vector2


func enter():
	original_direction = signf(enemy.player.global_position.x - enemy.global_position.x)
	enemy.last_horizontal_direction = original_direction
	
	"""if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Chase")
	else:
		enemy.animation_player.play("Left_Chase")"""
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	var distance_x = enemy.player.global_position.x - enemy.global_position.x
	var distance_y = enemy.player.global_position.y - enemy.global_position.y
	if distance_y.abs >= distance_x.abs and distance_y < 0.0:
		distance_to_player = Vector2(0, signf(distance_y))
	else:
		distance_to_player = Vector2(signf(distance_x), 0)
	change_shield_position(distance_to_player)
	
	evaluate_transitions()


func physics_update(_delta: float):
	if enemy.is_on_floor():
		if enemy.player != null:
			direction = signf(enemy.player.global_position.x - enemy.global_position.x)
			enemy.velocity.x += direction * enemy.move_speed * enemy.acceleration * _delta
			enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)
		else:
			enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)
	else:
		enemy.last_horizontal_direction = direction


func change_shield_position(shield_direction):
	shield.position = 16 * shield_direction
	if shield_direction.y != 0:
		shield.rotation = Vector2.UP.angle_to(shield_direction)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif enemy.defended == true:
		transitioned_state.emit(self, "ShieldHandDefend")
	elif enemy.velocity.x == 0 and enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandIdle")
	elif not enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandFall")
	elif enemy.player_in_range == true and enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandAttack")
