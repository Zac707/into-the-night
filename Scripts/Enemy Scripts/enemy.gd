extends CharacterBody2D


@export var move_speed: float = 80
@export var acceleration: float = 15.0  
@export var friction: float = 30.0     
@export var attack_speed: float = 100.0
@export var air_speed: float = 50.0
@export var gravity: float = 90.0
@export var attack_component: Area2D

var player: CharacterBody2D
var last_horizontal_direction: float
var player_in_range: bool


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		print("player found")


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null


func _on_attack_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_attack_activation_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
