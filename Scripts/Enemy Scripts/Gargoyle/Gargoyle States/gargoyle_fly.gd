extends StateGargoyle


class_name GargoyleFly


@export var path: Path2D

var current_direction: float
var prev_pos: Vector2
var dir: Vector2


func enter():
	if enemy.last_horizontal_direction == -1.0:
		enemy.animation_player.play("Left_Fly")
	else:
		enemy.animation_player.play("Fly")
	
	current_direction = enemy.last_horizontal_direction
	
	evaluate_transitions()


func exit():
	pass


func update(_delta: float):
	if dir.x > 0.0:
		enemy.animation_player.play("Fly")
		current_direction = 1.0
	elif dir.x < 0.0:
		enemy.animation_player.play("Left_Fly")
		current_direction = -1.0
	
	enemy.last_horizontal_direction = current_direction
	
	evaluate_transitions()


func physics_update(_delta: float):
	dir = (enemy.global_position - prev_pos).normalized()
	prev_pos = enemy.global_position


func evaluate_transitions():
	pass
