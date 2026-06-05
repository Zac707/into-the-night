extends State


class_name PlayerFall


var last_direction_angle: int
var transition_time: float = 0.05


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	transition_time -= _delta
	
	if player.is_on_floor() and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor():
		transitioned_state.emit(self, "PlayerRun")
	elif player.is_on_wall_only() and transition_time <= 0:
		transitioned_state.emit(self, "PlayerWalljump")
	
	if Input.is_action_pressed("up"):
		var vertical_input = PlayerMovement.get_vertical_input(player)
	elif player.last_horizontal_direction_pressed == "left":
		player.new_direction.emit(180)
	else:
		player.new_direction.emit(0)


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_flung_movement(player, _delta)
