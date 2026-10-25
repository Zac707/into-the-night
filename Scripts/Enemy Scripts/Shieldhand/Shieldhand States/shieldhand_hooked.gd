extends StateShieldHand


class_name ShieldHandHooked


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Hooked")
	else:
		enemy.animation_player.play("Left_Hooked")
	
	#shield.queue_free()
	enemy.velocity.x = enemy.last_horizontal_direction * 50
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif enemy.defenseless == true and enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandPanic")
	elif enemy.defenseless == true:
		transitioned_state.emit(self, "ShieldHandFall")


func on_animation_finished():
	enemy.defenseless = true
