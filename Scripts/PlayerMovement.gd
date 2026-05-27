extends Node


func get_gravity(player: CharacterBody2D) -> float:
	return player.jump_gravity if player.velocity.y < 0.0 else player.fall_gravity


func apply_gravity(player: CharacterBody2D, delta: float) -> void:
	player.velocity.y += get_gravity(player) * delta


func get_horizontal_input(player: CharacterBody2D) -> float:
	var input := 0.0
	if Input.is_action_pressed("right"):
		input = 1.0
		player.last_direction_pressed.emit(0)
	elif Input.is_action_pressed("left"):
		input = -1.0
		player.last_direction_pressed.emit(180)
	return input


func apply_horizontal_movement(player: CharacterBody2D, delta: float) -> void:
	var input := get_horizontal_input(player)
	player.velocity.x += input * player.move_speed * player.acceleration * delta
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	if input == 0.0:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * delta)
