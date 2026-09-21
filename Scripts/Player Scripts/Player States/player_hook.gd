extends State


class_name PlayerHook


@export var hookshot: Hookshot

var _is_hooked: bool = false
var _hook_point: Vector2 = Vector2.ZERO
var _approach_dir: Vector2 = Vector2.ZERO  # Direction when hook first latched
var animation_dict_throw: Dictionary = {Vector3(1, 0, 0): "Hook_Throw", Vector3(-1, 0, 0): "Left_Hook_Throw", Vector3(1, -1, 0): "Hook_Throw_Up", 
Vector3(-1, -1, 0): "Left_Hook_Throw_Up", Vector3(1, 0, 1): "Aerial_Hook_Throw", Vector3(-1, 0, 1): "Left_Aerial_Hook_Throw", 
Vector3(1, -1, 1): "Aerial_Hook_Throw_Up", Vector3(-1, -1, 1): "Left_Aerial_Hook_Throw_Up"}
var animation_dict_pull: Dictionary = {Vector3(1, 0, 0): "Hook_Pull", Vector3(-1, 0, 0): "Left_Hook_Pull", Vector3(1, -1, 0): "Hook_Pull_Up", 
Vector3(-1, -1, 0): "Left_Hook_Pull_Up", Vector3(1, 0, 1): "Hook_Pull", Vector3(-1, 0, 1): "Left_Hook_Pull", 
Vector3(1, -1, 1): "Hook_Pull_Up", Vector3(-1, -1, 1): "Left_Hook_Pull_Up"}
var aerial_down_granted: bool = false
var direction_data
var hover_duration: float = 0.0
#here to not have unhooked called twice. It can happen when locking onto an object, as hook.gd and this script both call it.
var already_unhooked: bool = false


func enter():
	direction_data = PlayerMovement.get_animation_direction(player, aerial_down_granted)
	for anim in animation_dict_throw:
		if anim == direction_data:
			player.animation_player.play(animation_dict_throw[anim])
	
	hookshot.fire()
	already_unhooked = false
	
	evaluate_transitions()


func exit():
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_approach_dir = Vector2.ZERO
	hover_duration = 0.0


func update(_delta: float):
	hover_duration -= _delta
	
	evaluate_transitions()


func physics_update(_delta: float):
	if _is_hooked:
		var to_hook: Vector2 = _hook_point - player.global_position
		var dist: float = to_hook.length()
		var current_dir: Vector2 = to_hook.normalized()
		# Arrived if: close enough, OR player has passed through the hook point
		# (dot product negative means direction has flipped — player overshot)
		var overshot: bool = _approach_dir != Vector2.ZERO and current_dir.dot(_approach_dir) < 0.0
		if dist <= 5.0 or overshot:
			_on_hook_unhooked()
			return
	
		var target_velocity: Vector2 = current_dir * dist * player.hook_spring_strength
		player.velocity = player.velocity.lerp(target_velocity, player.hook_damping)
		player.velocity.x = clamp(player.velocity.x, -player.max_move_speed, player.max_move_speed)
		if player.velocity.y > 0:
			player.velocity.y = 0
	
	# If the player has not hooked unto anything, he needs to have gravity applied in case he's in the air, but only when a certain time has passed so as to allow for a slight hover.
	# Also slow down his horizontal velocity, no matter how much time has passed.
	else:
		if hover_duration >= 0.0:
			player.velocity.y = move_toward(player.velocity.y, 0.0, 50)
		else:
			PlayerMovement.apply_gravity(player, _delta)
		if player.is_on_floor():
			#player.velocity.x = move_toward(player.velocity.x, 0.0, player.fling_friction * player.move_speed * _delta)
			player.velocity.x = 0.0
		else:
			#player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * _delta)
			player.velocity.x = move_toward(player.velocity.x, 0.0, 5)


func _on_hook_hooked(hooked_position: Variant) -> void:
	_hook_point = hooked_position
	_is_hooked = true
	if player.velocity.y > 0:
		player.velocity.y = 0
	# Record the initial approach direction to detect overshoot later
	_approach_dir = (_hook_point - player.global_position).normalized()
	
	for anim in animation_dict_throw:
		if anim == direction_data:
			player.animation_player.play(animation_dict_pull[anim])


func _on_hook_unhooked() -> void:
	# Only preserve X fling if there's meaningful horizontal speed.
	# Y is always kept so upward hook momentum carries through.
	if already_unhooked == true:
		return
	
	player.fling_velocity = Vector2(
		player.velocity.x if abs(player.velocity.x) > player.move_speed else 0.0,
		player.velocity.y
	)
	player.fling_timer = 0.0
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_approach_dir = Vector2.ZERO
	already_unhooked = true
	if player.is_on_floor():
		PlayerMovement.get_horizontal_input(player)
		transitioned_state.emit(self, "PlayerRun")
	else:
		transitioned_state.emit(self, "PlayerFall")


func evaluate_transitions():
	if player.hurt == true:
		transitioned_state.emit(self, "PlayerHurt")


func _on_hook_hook_sent(start_duration: Variant, return_duration: Variant) -> void:
	hover_duration = start_duration + return_duration/2
