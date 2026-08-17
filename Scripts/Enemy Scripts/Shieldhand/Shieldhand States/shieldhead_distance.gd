extends StateShieldHand


class_name ShieldHandDistance


@export var min_distance: float = 40.0
@export var max_distance: float = 60.0

var direction: float
var original_direction: float
var direction_switched: bool = false
var distance: float


func enter():
	original_direction = signf(enemy.player.global_position.x - enemy.global_position.x)
	enemy.last_horizontal_direction = original_direction


func exit():
	direction_switched = false


func update(_delta: float):
	distance = enemy.distance_to(enemy.player)


func physics_update(_delta: float):
	if enemy.is_on_floor():
		if enemy.player != null:
			direction = signf(enemy.player.global_position.x - enemy.global_position.x)
		elif enemy.player == null:
			enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)
		
		#check wether shieldhand should move towards or away fromplayer, or stay in place. Still needs to add animation to each separately
		if distance >= max_distance:
			enemy.velocity.x += direction * enemy.move_speed * enemy.acceleration * _delta
			enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)
		elif distance <= min_distance:
			enemy.velocity.x -= direction * enemy.move_speed * enemy.acceleration * _delta
			enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)
		else:
			hover
		
		if original_direction != direction:
			direction_switched = true
	else:
		enemy.last_horizontal_direction = direction


func hover():
	pass


func evaluate_transitions():
	pass
