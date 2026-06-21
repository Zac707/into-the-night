extends State


class_name PlayerAttack


var directional_input: Vector2
var bounce_executed: bool = false
var animation_dict: Dictionary = {Vector3(1, 0, 0): "Attack_Side", Vector3(-1, 0, 0): "Left_Attack_Side", Vector3(1, -1, 0): "Attack_Up", 
Vector3(-1, -1, 0): "Left_Attack_Up", Vector3(1, 0, 1): "Aerial_Attack_Side", Vector3(-1, 0, 1): "Left_Aerial_Attack_Side", 
Vector3(1, 1, 1): "Aerial_Attack_Down", Vector3(1, -1, 1): "Aerial_Attack_Up", Vector3(-1, 1, 1): "Left_Aerial_Attack_Down", 
Vector3(-1, -1, 1): "Left_Aerial_Attack_Up"}
var aerial_down_granted: bool = true


func enter():
	directional_input = PlayerMovement.get_last_direction_pressed(player)
	player.attack_component.position = directional_input * Vector2(15, 15)
	player.attack_component.rotation = Vector2.UP.angle_to(directional_input)
	
	var direction_data = PlayerMovement.get_animation_direction(player, aerial_down_granted)
	for anim in animation_dict:
		if anim == direction_data:
			player.animation_player.play(animation_dict[anim])


func exit():
	bounce_executed = false
	player.attack_component.position = Vector2(0, 0)
	player.attack_component.rotation = 0


func update(_delta: float):
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * _delta)
	else:
		PlayerMovement.apply_flung_movement(player, _delta)
		PlayerMovement.apply_gravity(player, _delta)
	
	for area in player.attack_component.get_overlapping_areas():
		if area.has_method("get_enemy_damage"):
			var attack = Attack.new()
			attack.attack_damage = 2
			attack.attack_direction = directional_input
			attack.knockback_force = 30
			area.get_enemy_damage(attack)
		if area.is_in_group("bouncing_object") and directional_input == Vector2(0, 1) and not player.is_on_floor():
			_bounce()

func physics_update(_delta: float):
	pass


func attack_finished():
	if not player.is_on_floor():
		transitioned_state.emit(self, "PlayerFall")
	else:
		transitioned_state.emit(self, "PlayerIdle")


func _bounce():
	if bounce_executed == false:
		player.velocity.y = player.jump_velocity
		bounce_executed = true
