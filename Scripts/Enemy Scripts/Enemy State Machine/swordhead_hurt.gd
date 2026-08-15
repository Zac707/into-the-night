extends StateSwordHead


class_name SwordHeadHurt


var actionable: bool = false


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Hurt")
	else:
		enemy.animation_player.play("Left_Hurt")
	
	enemy.velocity = enemy.health_component.knockback
	enemy.velocity.y = -80


func exit():
	enemy.hurt = false
	actionable = false


func update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if actionable == true:
		if enemy.is_on_floor():
			transitioned_state.emit(self, "SwordHeadIdle")
		else:
			transitioned_state.emit(self, "SwordHeadFall")


func on_animation_finished():
	enemy.velocity = Vector2.ZERO
	actionable = true
