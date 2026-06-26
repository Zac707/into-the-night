extends State


class_name PlayerRun


@export var coyote_time: float = 0.1

var last_direction_angle: int
var coyote_time_activated: bool = false


func enter():
	if player.last_horizontal_direction_pressed == "right":
		player.animation_player.play("Run")
	else:
		player.animation_player.play("Left_Run")
	evaluate_transitions()


func exit():
	coyote_time_activated = false
	coyote_time = 0.1


func update(_delta: float):
	if coyote_time_activated == true:
		coyote_time -= _delta
	evaluate_transitions()


func physics_update(_delta: float):
	PlayerMovement.apply_flung_movement(player, _delta)
	if coyote_time_activated == true:
		PlayerMovement.apply_gravity(player, _delta)


func evaluate_transitions():
	if Input.is_action_just_pressed("jump"):
		transitioned_state.emit(self, "PlayerJump")
	elif not player.is_on_floor():
		coyote_time_activated = true
		if coyote_time <= 0.0:
			transitioned_state.emit(self, "PlayerFall")
	elif Input.is_action_pressed("hook_test"):
		transitioned_state.emit(self, "PlayerHook")
	elif Input.is_action_pressed("attack"):
		transitioned_state.emit(self, "PlayerAttack")
	elif player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
