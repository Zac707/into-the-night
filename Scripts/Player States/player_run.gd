extends State


class_name PlayerRun


var last_direction_angle: int


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	if player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	if Input.is_action_just_pressed("jump"):
		transitioned_state.emit(self, "PlayerJump")
	if not player.is_on_floor():
		transitioned_state.emit(self, "PlayerFall")
	if Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")


func physics_update(_delta: float):
	PlayerMovement.apply_flung_movement(player, _delta)
