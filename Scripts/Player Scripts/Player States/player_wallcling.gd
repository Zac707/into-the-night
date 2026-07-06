extends State


class_name PlayerWallcling


var jump_executed: bool = false
var max_fall_speed: float = 100.0
var still_on_wall


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Wall_Cling")
	else:
		player.animation_player.play("Left_Wall_Cling")
	
	player.velocity.y = clamp(player.velocity.y, -20.0, max_fall_speed)
	jump_executed = false
	var wall_normal = player.get_wall_normal()
	player.wall_direction = "right" if wall_normal.x > 0 else "left"
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	still_on_wall = player.wall_check_left.is_colliding() or player.wall_check_right.is_colliding()
	
	evaluate_transitions()


func physics_update(_delta: float):
	player.velocity.y += player.gravity_on_wall * _delta
	player.velocity.y = clamp(player.velocity.y, -max_fall_speed, max_fall_speed)


func _jump():
	if not jump_executed:
		jump_executed = true


func evaluate_transitions():
	if player.hurt == true:
		transitioned_state.emit(self, "PlayerHurt")
	elif player.is_on_floor():
		transitioned_state.emit(self, "PlayerIdle")
	elif not jump_executed:
		if not still_on_wall:
			print("transitioning to fall")
			transitioned_state.emit(self, "PlayerFall")
		elif Input.is_action_pressed("left") and player.wall_direction == "left":
			transitioned_state.emit(self, "PlayerFall")
		elif Input.is_action_pressed("right") and player.wall_direction == "right":
			transitioned_state.emit(self, "PlayerFall")
		elif player.wall_direction == "left":
			if Input.is_action_just_pressed("jump") and Input.is_action_pressed("right"):
				_jump()
		elif player.wall_direction == "right":
			if Input.is_action_just_pressed("jump") and Input.is_action_pressed("left"):
				_jump()
	elif jump_executed:
		transitioned_state.emit(self, "PlayerWalljump")
