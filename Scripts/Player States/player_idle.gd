extends State


class_name PlayerIdle


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	if player.is_on_floor():
		if Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			transitioned_state.emit(self, "PlayerRun")
		elif Input.is_action_just_pressed("jump"):
			transitioned_state.emit(self, "PlayerJump")
		elif Input.is_action_pressed("hook_test"):
			transitioned_state.emit(self, "PlayerHook")
		elif Input.is_action_pressed("attack"):
			transitioned_state.emit(self, "PlayerAttack")
	
	PlayerMovement.get_last_direction_pressed(player)


func physics_update(_delta: float):
	pass
