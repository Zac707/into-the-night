extends CharacterBody2D


@export var move_speed: float = 40.0
@export var panick_speed: float = 60.0
@export var acceleration: float = 15.0  
@export var friction: float = 30.0     
@export var attack_speed: float = 0.0
@export var air_speed: float = 30.0
@export var gravity: float = 600.0
@export var attack_component: Area2D
@export var animation_player: AnimationPlayer
@export var health_component: Area2D

var player: CharacterBody2D
var last_horizontal_direction: float = -1.0
var last_shield_position: Vector2 = Vector2(0, 0)
var player_in_range: bool
var hurt: bool = false
var defended: bool = false
var defenseless: bool = false
var hooked: bool = false


func _ready() -> void:
	animation_player.play("emoticons_disabled")


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		animation_player.play("exclamation_point")


func _on_deactivation_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = null


func _on_attack_activation_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true


func _on_attack_activation_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
