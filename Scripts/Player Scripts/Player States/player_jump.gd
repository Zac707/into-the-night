extends State


class_name PlayerJump


var last_direction_angle: int


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Jump")
	else:
		player.animation_player.play("Left_Jump")
	_jump()
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	PlayerMovement.get_last_direction_pressed(player)
	evaluate_transitions()


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_horizontal_movement(player, _delta)
	if Input.is_action_just_released("jump") and PlayerMovement.get_gravity(player) == player.jump_gravity:
		player.velocity.y *= 0.3


func _jump():
	player.velocity.y = player.jump_velocity


func evaluate_transitions():
	if player.is_on_floor() and player.velocity.y >= 0 and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor() and player.velocity.y >= 0:
		transitioned_state.emit(self, "PlayerRun")
	elif player.velocity.y >= 0:
		transitioned_state.emit(self, "PlayerFall")
	elif Input.is_action_just_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif player.is_on_wall_only() and player.velocity.y > -10:
		transitioned_state.emit(self, "PlayerWallcling")
	elif Input.is_action_just_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
