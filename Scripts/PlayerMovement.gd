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


func apply_flung_horizontal_movement(player: CharacterBody2D, delta: float) -> void:
	var input := get_horizontal_input(player)
 
	if player.fling_velocity == Vector2.ZERO:
		# No active fling — behave normally
		apply_horizontal_movement(player, delta)
		return
 
	var fling_dir := signf(player.fling_velocity.x)
	var move_dir := input if input != 0.0 else fling_dir
 
	# Cancel fling if player inputs against the fling direction
	if input != 0.0 and signf(input) != fling_dir:
		player.fling_velocity = Vector2.ZERO
		apply_horizontal_movement(player, delta)
		return
 
	player.fling_timer += delta
	var t: float = clamp(player.fling_timer / player.fling_decay_duration, 0.0, 1.0)
 
	# Sample the curve: 0 = full fling speed, 1 = normal move_speed
	var curve_t: float = player.fling_decay_curve.sample(t)
	var fling_speed := absf(player.fling_velocity.x)
	var max_speed_this_frame := lerpf(fling_speed, player.move_speed, curve_t)
 
	# Apply acceleration as normal but clamp to the decaying ceiling
	player.velocity.x += move_dir * player.move_speed * player.acceleration * delta
	player.velocity.x = clamp(player.velocity.x, -max_speed_this_frame, max_speed_this_frame)
 
	if t >= 1.0:
		player.fling_velocity = Vector2.ZERO
