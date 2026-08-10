extends State


class_name PlayerLand


var actionable: bool = false


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Land")
	else:
		player.animation_player.play("Left_Land")


func exit():
	actionable = false


func update(_delta: float):
	PlayerMovement.get_last_direction_pressed(player)
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * _delta)
	
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if player.hurt == true:
		transitioned_state.emit(self, "PlayerHurt")
	elif actionable == true:
		transitioned_state.emit(self, "PlayerIdle")


func animation_finished() -> void:
	actionable = true
