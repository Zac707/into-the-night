extends State


class_name PlayerRun


var directions_currently_pressed: Dictionary = {"right_held" : false, "left_held" : false}
var last_direction_angle: int


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	var horizontal_input := _get_horizontal_input()
	player.velocity.x += player.horizontal_input * player.move_speed * player.acceleration * _delta
	player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * _delta)
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	
	if horizontal_input == 0:
		transitioned_state.emit(self, "PlayerIdle")
	if Input.is_action_just_pressed("jump"):
		transitioned_state.emit(self, "PlayerJump")


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
