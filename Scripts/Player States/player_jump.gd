extends State


class_name PlayerJump


var directions_currently_pressed: Dictionary = {"right_held" : false, "left_held" : false}
var last_direction_angle: int
var player_liftoff: bool = false

func enter():
	pass


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	# only called if Jump is pressed, therefore no need to check for is_action_pressed here
	if player.is_on_floor() and player_liftoff == false:
		_jump()
		player_liftoff = true
	if player.is_on_floor() and player_liftoff == true:
		player_liftoff = false
		# transition to different state, probably idle
	
	if Input.is_action_just_released("jump") and player._get_gravity() == player.jump_gravity:
		player.velocity.y *= 0.3
	var horizontal_input := _get_horizontal_input()
	player.velocity.x += player.horizontal_input * player.move_speed * player.acceleration * _delta
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * _delta)
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)


func _jump():
	player.velocity.y = player.jump_velocity


func _get_horizontal_input() -> float:
	var input := 0.0
	if Input.is_action_pressed("right") and not directions_currently_pressed.left_held:
		input = 1.0
		last_direction_angle = 0
		player.last_direction_pressed.emit(last_direction_angle)
		directions_currently_pressed.right_held = true
	elif Input.is_action_pressed("left") and not directions_currently_pressed.right_held:
		input = -1.0
		last_direction_angle = 180
		player.last_direction_pressed.emit(last_direction_angle)
		directions_currently_pressed.left_held = true
	
	if Input.is_action_just_released("right"):
		directions_currently_pressed.right_held = false
	if Input.is_action_just_released("left"):
		directions_currently_pressed.left_held = false
	
	return input
