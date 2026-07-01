extends Node


class_name State


@export var player: CharacterBody2D

var active: bool

signal transitioned_state


func enter():
	pass


func exit():
	pass


func update(_delta: float):
	pass


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	pass
