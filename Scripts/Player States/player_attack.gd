extends State


class_name PlayerAttack


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	for areas in player.attack_component.get_overlapping_areas():
		if areas.has_method("get_enemy_damage"):
			var attack = Attack.new()
			attack.attack_damage = 2
			attack.attack_direction = self.global_position
			# Up to change, must be one of two directions (left or right), not depending on the angle, so as to achieve concistency
			attack.knockback_force = 30
			areas.get_enemy_damage(attack)


func physics_update(_delta: float):
	pass
