extends State


class_name PlayerWalljump


@export var walljump_indicator: Sprite2D

var jump_direction: String
var jump_executed: bool = false
var max_fall_speed: float = 100.0
var time_until_transition: float = 0.0  # Class-level so it persists across frames


func enter():
	player.animation_player.play("Walljump")
	
	player.velocity.y = max(-20.0, player.velocity.y)
	jump_executed = false
	time_until_transition = 0.0
	var wall_normal = player.get_wall_normal()
	jump_direction = "right" if wall_normal.x > 0 else "left"


func exit():
	walljump_indicator.visible = false


func update(_delta: float):
	# Correct button check per wall side
	if jump_direction == "left":
		if Input.is_action_just_pressed("jump") and Input.is_action_pressed("right"):
			_jump()
	elif jump_direction == "right":
		if Input.is_action_just_pressed("jump") and Input.is_action_pressed("left"):
			_jump()

	if player.is_on_floor():
		transitioned_state.emit(self, "PlayerIdle")
	# Cancel to fall if player holds INTO the wall (no wall contact check needed)
	elif not jump_executed:
		if Input.is_action_pressed("left") and jump_direction == "left":
			transitioned_state.emit(self, "PlayerFall")
		elif Input.is_action_pressed("right") and jump_direction == "right":
			transitioned_state.emit(self, "PlayerFall")
	elif jump_executed and player.velocity.y > 0:
		# Apex reached — hand off to PlayerFall which uses normal fall_gravity
		transitioned_state.emit(self, "PlayerFall")



func physics_update(_delta: float):
	if not jump_executed:
		player.velocity.y += player.gravity_on_wall * _delta
		player.velocity.y = clamp(player.velocity.y, -max_fall_speed, max_fall_speed)
	else:
		PlayerMovement.apply_gravity(player, _delta)
		
		if jump_direction == "left":
			player.velocity.x += -player.move_speed * player.acceleration * _delta
			player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
		elif jump_direction == "right":
			player.velocity.x += player.move_speed * player.acceleration * _delta
			player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)


func _jump():
	if not jump_executed:
		player.velocity.y = player.walljump_velocity
		jump_executed = true
