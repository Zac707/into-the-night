extends State


class_name PlayerHook


var _is_hooked: bool
var _hook_point: Vector2
var _fling_speed: float


func enter():
	_is_hooked = false
	_hook_point = Vector2.ZERO



func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	PlayerMovement.apply_gravity(player, _delta)
	
	if _is_hooked:
		var to_hook: Vector2 = _hook_point - player.global_position
		var dist: float = to_hook.length()
		if dist > 5.0:
			var direction: Vector2 = to_hook.normalized()
			# Force scales linearly with distance (Hooke's law: F = k * x).
			var spring_force: Vector2 = direction * dist * player.hook_spring_strength
			# Damping reduces velocity along the pull direction to prevent oscillation.
			var damping_force: Vector2 = -player.velocity * player.hook_damping
			player.velocity += (spring_force + damping_force) * _delta
			if player.velocity.y >= 0:
				player.velocity.y = 0
		else:
			_is_hooked = false
			_hook_point = Vector2.ZERO
			#_hook_grace_timer = 0.5
			_fling_speed = player.velocity.x


func _on_hook_hooked(hooked_position: Variant) -> void:
	_hook_point = hooked_position
	_is_hooked = true
	print("hooked")


func _on_hook_unhooked() -> void:
	_is_hooked = false
	_hook_point = Vector2.ZERO
	#_hook_grace_timer = 0.5
	_fling_speed = player.velocity.x
	if player.is_on_floor():
		transitioned_state.emit(self, "PlayerRun")
	else:
		transitioned_state.emit(self, "PlayerFall")
