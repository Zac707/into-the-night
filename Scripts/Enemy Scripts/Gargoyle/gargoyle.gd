extends CharacterBody2D


@export var move_speed: float = 40.0
@export var acceleration: float = 10.0  
@export var friction: float = 25.0  
@export var animation_player: AnimationPlayer

var last_horizontal_direction: float = -1.0
var hurt: bool = false


func _physics_process(delta: float) -> void:
	move_and_slide()

#test
