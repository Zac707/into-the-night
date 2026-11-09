extends State


class_name PlayerAttack


@export var effect_duration: float = 0.3
@export var attack_effect: PackedScene

var chosen_effect: Array
var attack_effect_dict: Dictionary 
var effect_allowed: bool = false

var directional_input: Vector2
var bounce_executed: bool = false
var animation_dict: Dictionary = {Vector3(1, 0, 0): "Attack_Side", Vector3(-1, 0, 0): "Left_Attack_Side", Vector3(1, -1, 0): "Attack_Up", 
Vector3(-1, -1, 0): "Left_Attack_Up", Vector3(1, 0, 1): "Aerial_Attack_Side", Vector3(-1, 0, 1): "Left_Aerial_Attack_Side", 
Vector3(1, 1, 1): "Aerial_Attack_Down", Vector3(1, -1, 1): "Aerial_Attack_Up", Vector3(-1, 1, 1): "Left_Aerial_Attack_Down", 
Vector3(-1, -1, 1): "Left_Aerial_Attack_Up"}
var aerial_down_granted: bool = true
var is_airborne: bool = false
var attacked_areas: Array = []


func enter():
	directional_input = PlayerMovement.get_last_direction_pressed(player)
	
	attack_effect_dict = {"Attack_Side": [attack_effect, Vector2(15, 0), Vector2(1.0, 1.0)], "Left_Attack_Side": [attack_effect, Vector2(-15, 0), Vector2(-1.0, 1.0)], "Attack_Up": [attack_effect, Vector2(0, -15), Vector2(1.0, 1.0)], 
"Left_Attack_Up": [attack_effect, Vector2(0, -15), Vector2(-1.0, 1.0)], "Aerial_Attack_Side": [attack_effect, Vector2(15, 0), Vector2(1.0, 1.0)], "Left_Aerial_Attack_Side": [attack_effect, Vector2(-15, 0), Vector2(-1.0, 1.0)], 
"Aerial_Attack_Down": [attack_effect, Vector2(0, 15), Vector2(1.0, -1.0)], "Aerial_Attack_Up": [attack_effect, Vector2(0, -15), Vector2(1.0, 1.0)],"Left_Aerial_Attack_Down": [attack_effect, Vector2(0, 15), Vector2(-1.0, -1.0)], 
"Left_Aerial_Attack_Up": [attack_effect, Vector2(0, -15), Vector2(-1.0, 1.0)]}
	
	var direction_data = PlayerMovement.get_animation_direction(player, aerial_down_granted)
	for anim in animation_dict:
		if anim == direction_data:
			player.animation_player.play(animation_dict[anim])
			for effect in attack_effect_dict:
				if effect == animation_dict[anim]:
					chosen_effect = attack_effect_dict[effect]
	
	if player.is_on_floor() == false:
		is_airborne = true
	
	evaluate_transitions()


func exit():
	bounce_executed = false
	player.attack_component.position = Vector2(0, 0)
	player.attack_component.rotation = 0
	is_airborne = false
	attacked_areas.clear()
	chosen_effect = []
	effect_allowed = false
	player.bouncing = false


func update(_delta: float):
	for area in player.attack_component.get_overlapping_areas():
		if area.has_method("get_enemy_damage") and not attacked_areas.has(area):
			effect_allowed = true
			var attack = Attack.new()
			attack.attack_damage = 1
			attack.attack_direction = directional_input
			attack.knockback_force = 30
			area.get_enemy_damage(attack)
			attacked_areas.append(area)
			
		if area.is_in_group("bouncing_object") and directional_input == Vector2(0, 1) and not player.is_on_floor():
			if not attacked_areas.has(area):
				effect_allowed = true
				attacked_areas.append(area)
			_bounce()
			
	
	spawn_effect()
	evaluate_transitions()


func physics_update(_delta: float):
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.move_speed * _delta)
	else:
		PlayerMovement.apply_flung_movement(player, _delta)
		PlayerMovement.apply_gravity(player, _delta)


func attack_finished():
	if not player.is_on_floor():
		transitioned_state.emit(self, "PlayerFall")
	else:
		transitioned_state.emit(self, "PlayerIdle")


func _bounce():
	if bounce_executed == false:
		player.velocity.y = player.bounce_velocity
		bounce_executed = true
		player.bouncing = true


func spawn_effect():
	if effect_allowed:
		var pos: Vector2 = chosen_effect[1] + player.global_position
		SpawnManager.place_effects(chosen_effect[0], pos, chosen_effect[2], effect_duration)
		effect_allowed = false


func evaluate_transitions():
	if player.hurt == true:
		transitioned_state.emit(self, "PlayerHurt")
	elif is_airborne:
		if player.is_on_floor():
			transitioned_state.emit(self, "PlayerLand")
