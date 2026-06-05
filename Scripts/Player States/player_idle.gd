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
	if Input.is_action_just_pressed("jump"):
		transitioned_state.emit(self, "PlayerJump")
	if Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	
	if Input.is_action_pressed("up"):
		var vertical_input = PlayerMovement.get_vertical_input(player)
	elif player.last_horizontal_direction_pressed == "left":
		player.new_direction.emit(180)
	else:
		player.new_direction.emit(0)


func physics_update(_delta: float):
	pass
