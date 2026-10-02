extends Area2D


@export var hitbox: CollisionShape2D


func on_attack_started()-> void:
	hitbox.disabled = false


func on_attack_finished()-> void:
	hitbox.disabled = true
