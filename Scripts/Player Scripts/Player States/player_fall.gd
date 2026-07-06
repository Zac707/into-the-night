extends State


class_name PlayerFall


@export var jump_buffer_duration: float = 0.05

var last_direction_angle: int
var transition_time: float = 0.00
var jump_buffer_timer: float = 0.0


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Fall")
	else:
		player.animation_player.play("Left_Fall")
	jump_buffer_timer = 0.0
	
	evaluate_transitions()


func exit():
	transition_time = 0.00
	jump_buffer_timer = 0.0


func update(_delta: float):
	transition_time += _delta
	PlayerMovement.get_last_direction_pressed(player)
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_duration
	elif jump_buffer_timer > 0.0:
		jump_buffer_timer -= _delta
	
	evaluate_transitions()


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_flung_movement(player, _delta)


func evaluate_transitions():
	if player.hurt == true:
		transitioned_state.emit(self, "PlayerHurt")
	elif player.is_on_floor() and jump_buffer_timer > 0.0:
		transitioned_state.emit(self, "PlayerJump")
	elif player.is_on_floor() and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor():
		PlayerMovement.get_horizontal_input(player)
		transitioned_state.emit(self, "PlayerRun")
	elif Input.is_action_just_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif player.is_on_wall_only() and transition_time >= 0.05 and player.velocity.y > -10:
		transitioned_state.emit(self, "PlayerWallcling")
	elif Input.is_action_just_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
