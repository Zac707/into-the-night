extends State


class_name PlayerIdle


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Idle")
	else:
		player.animation_player.play("Left_Idle")


func exit():
	pass


func update(_delta: float):
	if player.is_on_floor():
		if Input.is_action_just_pressed("jump"):
			transitioned_state.emit(self, "PlayerJump")
		elif Input.is_action_pressed("hook_test"):
			transitioned_state.emit(self, "PlayerHook")
		elif Input.is_action_pressed("attack"):
			transitioned_state.emit(self, "PlayerAttack")
		elif Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			PlayerMovement.get_horizontal_input(player)
			transitioned_state.emit(self, "PlayerRun")
	
	PlayerMovement.get_last_direction_pressed(player)


func physics_update(_delta: float):
	pass
