extends StateShieldHand


class_name ShieldHandHooked


func enter():
	enemy.defenseless = true
	#shield.queue_free()
	
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


func on_animation_finished():
	enemy.defenseless = true
