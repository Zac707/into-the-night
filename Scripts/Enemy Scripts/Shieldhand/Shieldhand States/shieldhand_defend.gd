extends StateShieldHand


class_name ShieldHandDefend


var actionable: bool = false


func enter():
	enemy.velocity = enemy.health_component.knockback
	shield.shield_available = false
	actionable = false
	
	if enemy.last_shield_position.y == 0.0:
		if enemy.last_shield_position.x == 1.0:
			enemy.animation_player.play("Defend")
		else:
			enemy.animation_player.play("Left_Defend")
	else:
		if enemy.last_horizontal_direction == 1.0:
			enemy.animation_player.play("Defend_up")
		else:
			enemy.animation_player.play("Left_Defend_up")


func exit():
	enemy.defended = false
	shield.shield_available = true
	actionable = false


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * _delta)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif actionable == true and not enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandFall")
	elif actionable == true and enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandDistance")


func on_animation_finished():
	actionable = true
