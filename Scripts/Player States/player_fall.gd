extends State


class_name PlayerFall


var last_direction_angle: int


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	if player.is_on_floor() and player.velocity.y >= 0:
		transitioned_state.emit(self, "PlayerIdle")
	if player.is_on_floor():
		transitioned_state.emit(self, "PlayerIdle")


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	PlayerMovement.apply_horizontal_movement(player, _delta)
