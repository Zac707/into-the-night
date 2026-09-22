extends StateShieldHand


class_name ShieldHandFall


func enter():
	shield.shield_available = false
	
	evaluate_transitions()


func exit():
	shield.shield_available = true


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	if enemy.velocity.x != 0.0:
		enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif enemy.is_on_floor() and enemy.defenseless == false:
		transitioned_state.emit(self, "ShieldHandDistance")
	elif enemy.is_on_floor() and enemy.defenseless == true:
		transitioned_state.emit(self, "ShieldHandPanick")
