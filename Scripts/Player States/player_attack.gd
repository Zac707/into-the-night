extends State


class_name PlayerAttack


var directional_input: Vector2


func enter():
	if player.is_on_floor():
		player.velocity.x = 0
	
	directional_input = PlayerMovement.get_last_direction_pressed(player)
	player.attack_component.position = directional_input * Vector2(10, 10)
	player.attack_component.rotation = Vector2.UP.angle_to(directional_input)
	player.animation_player.play("Attack")



func exit():
	pass


func update(_delta: float):
	for areas in player.attack_component.get_overlapping_areas():
		if areas.has_method("get_enemy_damage"):
			var attack = Attack.new()
			attack.attack_damage = 2
			attack.attack_direction = directional_input
			attack.knockback_force = 30
			areas.get_enemy_damage(attack)


func physics_update(_delta: float):
	pass


func attack_finished():
	if player.velocity.x == 0:
		transitioned_state.emit(self, "PlayerIdle")
	elif not player.is_on_floor():
		transitioned_state.emit(self, "PlayerFall")
