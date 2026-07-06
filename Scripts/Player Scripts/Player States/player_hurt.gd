extends State


class_name PlayerHurt


var actionable: bool = false


func enter():
	if player.health_component.knockback.normalized() == Vector2(1.0, 0.0):
		player.animation_player.play("Left_Hurt")
	else:
		player.animation_player.play("Hurt")


func exit():
	player.hurt = false
	actionable = false


func update(_delta: float):
	player.velocity = player.health_component.knockback
	player.health_component.knockback = player.health_component.knockback.lerp(Vector2.ZERO, 10 * _delta)
	
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if actionable == true:
		if player.is_on_floor():
			transitioned_state.emit(self, "PlayerIdle")
		else:
			transitioned_state.emit(self, "PlayerFall")


func on_animation_finished():
	actionable = true
	print("actionable again")
