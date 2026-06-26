extends State


class_name PlayerWalljump


var max_fall_speed: float = 100.0
var time_until_transition: float = 0.0


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Fall")
	else:
		player.animation_player.play("Left_Fall")
	
	_jump()


func exit():
	time_until_transition = 0.0


func update(_delta: float):
	time_until_transition += _delta
	evaluate_transitions()


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	
	if player.wall_direction == "left":
		player.velocity.x += -player.move_speed * player.acceleration * _delta
		player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	elif player.wall_direction == "right":
		player.velocity.x += player.move_speed * player.acceleration * _delta
		player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)


func _jump():
	player.velocity.y = player.walljump_velocity
	if player.wall_direction == "left":
		player.velocity.x = -player.move_speed
	elif player.wall_direction == "right":
		player.velocity.x = player.move_speed


func evaluate_transitions():
	if player.is_on_floor():
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_wall_only() and time_until_transition >= 0.15:
		transitioned_state.emit(self, "PlayerWallcling")
	elif time_until_transition >= 0.2:
		# Apex reached — hand off to PlayerFall which uses normal fall_gravity
		transitioned_state.emit(self, "PlayerFall")
