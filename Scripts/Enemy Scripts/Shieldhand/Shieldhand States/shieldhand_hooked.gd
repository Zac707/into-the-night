extends StateShieldHand


class_name ShieldHandHooked


@export var shield: Area2D


func enter():
	enemy.defenseless = true
	shield.queue_free()


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	pass
