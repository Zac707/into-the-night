extends State


class_name PlayerJump


var last_direction_angle: int


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Jump")
	else:
		player.animation_player.play("Left_Jump")
	_jump()


func exit():
	pass


func update(_delta: float):
	if player.is_on_floor() and player.velocity.y >= 0 and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor() and player.velocity.y >= 0:
		transitioned_state.emit(self, "PlayerRun")
	elif Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif player.is_on_wall_only():
		transitioned_state.emit(self, "PlayerWallcling")
	elif Input.is_action_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
	
	PlayerMovement.get_last_direction_pressed(player)


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	
	if Input.is_action_just_released("jump") and PlayerMovement.get_gravity(player) == player.jump_gravity:
		player.velocity.y *= 0.3
	
	PlayerMovement.apply_horizontal_movement(player, _delta)


func _jump():
	player.velocity.y = player.jump_velocity
