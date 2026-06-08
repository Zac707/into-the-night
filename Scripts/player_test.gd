extends CharacterBody2D

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var walljump_velocity: float = ((2.0 * walljump_height) / walljump_time_to_peak) * -1.0
@onready var walljump_gravity: float = ((-2.0 * walljump_height) / (walljump_time_to_peak * walljump_time_to_peak)) * -1.0

@export var move_speed: float = 100
@export var jump_height: float = 30
@export var jump_time_to_peak: float = 0.3
@export var jump_time_to_descent: float = 0.2
@export var acceleration: float = 15.0  
@export var friction: float = 30.0     
@export var hook_spring_strength: float = 50.0
@export var hook_damping: float = 0.05
@export var fling_decay_duration: float = 2.0
@export var fling_decay_curve: Curve
@export var fling_friction: float = 5.0
@export var gravity_on_wall: float = 10
@export var walljump_height: float = 15
@export var walljump_time_to_peak: float = 0.15
@export var attack_component: Area2D
@export var health_component: Area2D

var _horizontal: float = 0.0
var last_direction_angle: int
var directions_currently_pressed: Dictionary = {"right_held" : false, "left_held" : false}
var _fling_speed: float
var fling_velocity: Vector2 = Vector2.ZERO
var fling_timer: float = 0.0
var last_horizontal_direction_pressed: String

signal new_direction

func _physics_process(delta: float) -> void:
	move_and_slide()
