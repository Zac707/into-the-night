extends State


class_name PlayerHook


var _is_hooked: bool = false
var _hook_point: Vector2 = Vector2.ZERO
var _approach_dir: Vector2 = Vector2.ZERO  # Direction when hook first latched


func enter():
	# Do NOT reset _is_hooked here — hooked signal may fire before transition completes
	pass


func exit():
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_approach_dir = Vector2.ZERO


func update(_delta: float):
	pass


func physics_update(_delta: float):
	if _is_hooked:
		var to_hook: Vector2 = _hook_point - player.global_position
		var dist: float = to_hook.length()
		var current_dir: Vector2 = to_hook.normalized()

		# Arrived if: close enough, OR player has passed through the hook point
		# (dot product negative means direction has flipped — player overshot)
		var overshot: bool = _approach_dir != Vector2.ZERO and current_dir.dot(_approach_dir) < 0.0
		if dist <= 5.0 or overshot:
			_release_hook()
			return

		var target_velocity: Vector2 = current_dir * dist * player.hook_spring_strength
		player.velocity = player.velocity.lerp(target_velocity, player.hook_damping)
		if player.velocity.y > 0:
			player.velocity.y = 0
	else:
		PlayerMovement.apply_gravity(player, _delta)


func _release_hook() -> void:
	# Store fling velocity on player so subsequent states can decay it
	player.fling_velocity = player.velocity
	player.fling_timer = 0.0
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_approach_dir = Vector2.ZERO
	transitioned_state.emit(self, "PlayerFall")


func _on_hook_hooked(hooked_position: Variant) -> void:
	_hook_point = hooked_position
	_is_hooked = true
	if player.velocity.y > 0:
		player.velocity.y = 0
	# Record the initial approach direction to detect overshoot later
	_approach_dir = (_hook_point - player.global_position).normalized()


func _on_hook_unhooked() -> void:
	player.fling_velocity = player.velocity
	player.fling_timer = 0.0
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_approach_dir = Vector2.ZERO
	if player.is_on_floor():
		transitioned_state.emit(self, "PlayerRun")
	else:
		transitioned_state.emit(self, "PlayerFall")
