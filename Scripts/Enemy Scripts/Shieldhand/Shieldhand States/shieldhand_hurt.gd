extends StateShieldHand


class_name ShieldHandHurt


var actionable: bool = false


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Hurt")
	else:
		enemy.animation_player.play("Left_Hurt")
	
	enemy.velocity = enemy.health_component.knockback
	enemy.velocity.y = -80
	
	shield.shield_available = false


func exit():
	enemy.hurt = false
	actionable = false
	shield.shield_available = true


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * _delta)


func evaluate_transitions():
	if actionable == true:
		if enemy.is_on_floor() and enemy.defenseless == false:
			transitioned_state.emit(self, "ShieldHandDistance")
		elif enemy.is_on_floor() and enemy.defenseless == true:
			transitioned_state.emit(self, "ShieldHandPanick")
		else:
			transitioned_state.emit(self, "ShielödHandFall")


func on_animation_finished():
	actionable = true
