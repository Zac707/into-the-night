extends Area2D


@export var max_health:= 2.0
@export var enemy: CharacterBody2D

var health : float


func _ready():
	health = max_health


func get_enemy_damage(attack : Attack):
	health -= attack.attack_damage
	var knockback_direction = attack.attack_direction.direction_to(enemy.global_position)
	var knockback = attack.knockback_force * knockback_direction
	enemy.global_position += knockback
	enemy.move_and_slide() 
	if health <= 0:
		enemy.queue_free()
