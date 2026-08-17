extends StateSwordHead


class_name SwordHeadAttack


var attack_complete: bool = false
var attack_started: bool = false


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Attack")
	else:
		enemy.animation_player.play("Left_Attack")
	
	evaluate_transitions()


func exit():
	attack_complete = false
	attack_started = false


func update(_delta: float):
	if attack_started == false:
		return
	
	for area in enemy.attack_component.get_overlapping_areas():
		if area.has_method("get_player_damage"):
			var attack = Attack.new()
			attack.attack_damage = 1
			attack.attack_direction = Vector2(enemy.last_horizontal_direction, 0.0)
			attack.knockback_force = 100
			area.get_player_damage(attack)
	
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	enemy.velocity.x += enemy.last_horizontal_direction * enemy.attack_speed * enemy.acceleration * _delta
	enemy.velocity.x = clamp(enemy.velocity.x, -enemy.attack_speed, enemy.attack_speed)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "SwordHeadHurt")
	elif attack_complete and enemy.is_on_floor():
		transitioned_state.emit(self, "SwordHeadConfused")
	elif attack_complete:
		transitioned_state.emit(self, "SwordHeadFall")


func start_attack() -> void:
	attack_started = true


func on_attack_finished() -> void:
	attack_complete = true
