extends State


class_name PlayerFall


var last_direction_angle: int
var transition_time: float = 0.00


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Fall")
	else:
		player.animation_player.play("Left_Fall")


func exit():
	transition_time = 0.00


func update(_delta: float):
	transition_time += _delta
	
	if player.is_on_floor() and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor():
		PlayerMovement.get_horizontal_input(player)
		transitioned_state.emit(self, "PlayerRun")
	elif Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif player.is_on_wall_only() and transition_time >= 0.05:
		transitioned_state.emit(self, "PlayerWallcling")
	elif Input.is_action_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
	
	PlayerMovement.get_last_direction_pressed(player)


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_flung_movement(player, _delta)
