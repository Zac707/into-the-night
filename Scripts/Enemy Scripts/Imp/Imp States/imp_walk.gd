extends StateImp


class_name ImpWalk


@export var raycast_ground_left: RayCast2D
@export var raycast_ground_right: RayCast2D
@export var raycast_wall_left: RayCast2D
@export var raycast_wall_right: RayCast2D

var current_direction: float


func enter():
	if enemy.last_horizontal_direction == -1.0:
		enemy.animation_player.play("Left_Walk")
	else:
		enemy.animation_player.play("Walk")
	
	current_direction = enemy.last_horizontal_direction
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	if raycast_ground_left.is_colliding() == false:
		current_direction = 1.0
		enemy.animation_player.play("Left_Walk")
	elif raycast_ground_right.is_colliding() == false:
		current_direction = -1.0
		enemy.animation_player.play("Walk")
	elif raycast_wall_right.is_colliding():
		current_direction = -1.0
		enemy.animation_player.play("Walk")
	elif raycast_wall_left.is_colliding():
		current_direction = 1.0
		enemy.animation_player.play("Left_Walk")
	
	enemy.last_horizontal_direction = current_direction
	
	evaluate_transitions()


func physics_update(_delta: float):
	enemy.velocity.x += current_direction * enemy.move_speed * enemy.acceleration * _delta
	enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)


func evaluate_transitions():
	pass
