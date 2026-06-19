extends Node


func get_gravity(player: CharacterBody2D) -> float:
	return player.jump_gravity if player.velocity.y < 0.0 else player.fall_gravity


func apply_gravity(player: CharacterBody2D, delta: float) -> void:
	player.velocity.y += get_gravity(player) * delta


func get_horizontal_input(player: CharacterBody2D) -> float:
	var input := 0.0
	if Input.is_action_pressed("right"):
		input = 1.0
		player.new_direction.emit(0)
		player.last_horizontal_direction_pressed = "right"
	elif Input.is_action_pressed("left"):
		input = -1.0
		player.new_direction.emit(180)
		player.last_horizontal_direction_pressed = "left"
	return input


func get_vertical_input(player: CharacterBody2D) -> float:
	var vertical_input := 0.0
	if Input.is_action_pressed("up"):
		vertical_input = -1.0
		player.new_direction.emit(-90)
	elif Input.is_action_pressed("down"):
		vertical_input = 1.0
		player.new_direction.emit(90)
	return vertical_input


func get_last_direction_pressed(player: CharacterBody2D) -> Vector2:
	var last_input: Vector2
	var vertical_input = get_vertical_input(player)
	if vertical_input == -1.0:
		last_input = Vector2(0, -1)
	elif vertical_input == 1.0:
		last_input = Vector2(0, 1)
	elif player.last_horizontal_direction_pressed == "left":
		player.new_direction.emit(180)
		last_input = Vector2(-1, 0)
	else:
		player.new_direction.emit(0)
		last_input = Vector2(1, 0)
	return last_input


func apply_horizontal_movement(player: CharacterBody2D, delta: float) -> void:
	var input := get_horizontal_input(player)
	player.velocity.x += input * player.move_speed * player.acceleration * delta
	player.velocity.x = clamp(player.velocity.x, -player.move_speed, player.move_speed)
	if input == 0.0:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * delta)


func apply_flung_movement(player: CharacterBody2D, delta: float) -> void:
	var input := get_horizontal_input(player)
	var vertical_input := get_vertical_input(player)
	if player.fling_velocity == Vector2.ZERO:
		apply_horizontal_movement(player, delta)
		return
	
	var fling_dir := signf(player.fling_velocity.x)
	# Inputting against the fling direction cancels it immediately
	if input != 0.0 and signf(input) != fling_dir:
		player.fling_velocity = Vector2.ZERO
		apply_horizontal_movement(player, delta)
		return
	
	# fling_timer will progressively approach 3 seconds, returning a value between 1 and 0 from 0 to 3 seconds, afterwards 1
	player.fling_timer += delta
	var t: float = clamp(player.fling_timer / player.fling_decay_duration, 0.0, 1.0)
	
	# Curve maps t → how far we've decayed toward normal move_speed
	# curve_t=0 means still at full fling speed, curve_t=1 means back to move_speed
	var curve_t: float = player.fling_decay_curve.sample(t)
	var fling_speed := absf(player.fling_velocity.x)
	var speed_ceiling := lerpf(fling_speed, player.move_speed, curve_t)
	
	# Clamp current velocity down to the decaying ceiling — no re-acceleration.
	# This is what actually produces the slowdown.
	player.velocity.x = clamp(player.velocity.x, -speed_ceiling, speed_ceiling)
	
	if input != 0.0: 
		player.velocity.x = move_toward(player.velocity.x, player.move_speed if input == 1.0 else -player.move_speed, curve_t * player.move_speed * delta)
		print(player.velocity.x," ", player.fling_timer)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.fling_friction * player.move_speed * delta)
	# Then clamp to the decaying ceiling so velocity can never climb back up
	player.velocity.x = clamp(player.velocity.x, -speed_ceiling, speed_ceiling)
	
	if t >= 1.0:
		player.fling_velocity = Vector2.ZERO


# Function specifically for hookshot and attack. x and y value of animation_data return the direction of the move. z returns wether they are grounded.
# The Scripts will contain dictionnaries with every Vector3 corresponding to eone animation.
# Grounded downwards animation don't exist, which is why we can safely ignore them. However, aerial downwards attack are possible,
# while aerial downwards hokshoting is not. A check is needed to see if aerial downwards aim should be returned, therefore the transmitted bool is necessary.
func get_animation_direction(player: CharacterBody2D, aerial_down: bool) -> Vector3:
	var animation_data: Vector3
	var directional_input = PlayerMovement.get_last_direction_pressed(player)
	var new_direction = player.last_horizontal_direction_pressed
	
	if player.is_on_floor():
		if directional_input == Vector2(0, 1):
			animation_data = Vector3(1, 0, 0) if new_direction == "right" else Vector3(-1, 0, 0) # grounded side
		if directional_input == Vector2(0, -1):
			animation_data = Vector3(1, -1, 0) if new_direction == "right" else Vector3(-1, -1, 0) # grounded up
		else:
			animation_data = Vector3(1, 0, 0) if new_direction == "right" else Vector3(-1, 0, 0) # grounded side
	else:
		if directional_input == Vector2(1, 0):
			animation_data = Vector3(1, 0, 1) # aerial right
		elif directional_input == Vector2(-1, 0):
			animation_data = Vector3(-1, 0, 1) # aerial left
		elif directional_input == Vector2(0, 1):
			if aerial_down == true:
				animation_data = Vector3(1, 1, 1) if new_direction == "right" else Vector3(-1, 1, 1) # aerial down
			else:
				animation_data = Vector3(1, 0, 1) if new_direction == "right" else Vector3(-1, 0, 1) # aerial side
		elif directional_input == Vector2(0, -1):
			animation_data = Vector3(1, -1, 1) if new_direction == "right" else Vector3(-1, -1, 1) # aerial up
	return animation_data
