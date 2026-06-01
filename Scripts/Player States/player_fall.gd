extends State


class_name PlayerFall


var last_direction_angle: int


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	if player.is_on_floor() and player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif player.is_on_floor():
		transitioned_state.emit(self, "PlayerRun")


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_flung_horizontal_movement(player, _delta)
