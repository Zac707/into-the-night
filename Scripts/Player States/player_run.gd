extends State


class_name PlayerRun


var last_direction_angle: int


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Run")
	else:
		player.animation_player.play("Left_Run")


func exit():
	pass


func update(_delta: float):
	if Input.is_action_just_pressed("jump"):
		transitioned_state.emit(self, "PlayerJump")
	elif not player.is_on_floor():
		transitioned_state.emit(self, "PlayerFall")
	elif Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif Input.is_action_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
	elif player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")


func physics_update(_delta: float):
	PlayerMovement.apply_flung_movement(player, _delta)
