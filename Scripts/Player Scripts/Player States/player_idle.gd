extends State


class_name PlayerIdle


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Idle")
	else:
		player.animation_player.play("Left_Idle")
	
	evaluate_transitions()
	print("state READY ", player.position, " ", player.hurtbox.position, " ", player.sprite.position)


func exit():
	pass


func update(_delta: float):
	PlayerMovement.get_last_direction_pressed(player)
	
	evaluate_transitions()


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)


func evaluate_transitions():
	if player.is_on_floor():
		if player.hurt == true:
			transitioned_state.emit(self, "PlayerHurt")
		elif Input.is_action_just_pressed("jump"):
			transitioned_state.emit(self, "PlayerJump")
		elif Input.is_action_just_pressed("hook_test"):
			transitioned_state.emit(self, "PlayerHook")
		elif Input.is_action_just_pressed("attack"):
			transitioned_state.emit(self, "PlayerAttack")
		elif Input.is_action_pressed("right") or Input.is_action_pressed("left"):
			PlayerMovement.get_horizontal_input(player)
			transitioned_state.emit(self, "PlayerRun")
