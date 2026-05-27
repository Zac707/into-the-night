extends CharacterBody2D

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var move_speed: float
@export var jump_height: float
@export var jump_time_to_peak: float
@export var jump_time_to_descent: float
@export var acceleration: float = 15.0  
@export var friction: float = 30.0     
@export var hook_spring_strength: float = 15.0
@export var hook_damping: float = 0.05

var _horizontal: float = 0.0
var last_direction_angle: int
var directions_currently_pressed: Dictionary = {"right_held" : false, "left_held" : false}
var _fling_speed: float

signal last_direction_pressed

func _physics_process(delta: float) -> void:
	move_and_slide()
