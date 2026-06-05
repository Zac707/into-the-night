extends State


class_name PlayerJump


var last_direction_angle: int


func enter():
	_jump()


func exit():
	pass


func update(_delta: float):
	if Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif player.is_on_floor() and player.velocity.y >= 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_wall_only():
		transitioned_state.emit(self, "PlayerWalljump")
	
	if Input.is_action_pressed("up"):
		var vertical_input = PlayerMovement.get_vertical_input(player)
	elif player.last_horizontal_direction_pressed == "left":
		player.new_direction.emit(180)
	else:
		player.new_direction.emit(0)


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	
	if Input.is_action_just_released("jump") and PlayerMovement.get_gravity(player) == player.jump_gravity:
		player.velocity.y *= 0.3
	
	PlayerMovement.apply_horizontal_movement(player, _delta)


func _jump():
	player.velocity.y = player.jump_velocity
