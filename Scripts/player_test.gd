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
var _is_hooked: bool = false
var _hook_point: Vector2 = Vector2.ZERO
var _hook_grace_timer: float
var _fling_speed: float

signal last_direction_pressed

func _physics_process(delta: float) -> void:
	var horizontal_input := _get_horizontal_input()
	velocity.x += horizontal_input * move_speed * acceleration * delta
	velocity.y += _get_gravity() * delta
	
	if _hook_grace_timer > 0.0:
		_hook_grace_timer -= delta
	var grace_active := _hook_grace_timer > 0.0
	if not _is_hooked and horizontal_input == 0.0:
		velocity.x = move_toward(velocity.x, 0.0, friction * move_speed * delta)
	# Clamp so normal movement can't exceed move_speed (hook can exceed it).
	if not _is_hooked and grace_active == false:
		velocity.x = clamp(velocity.x, -move_speed, move_speed)
	if not _is_hooked and grace_active == true:
		velocity.x = clamp(velocity.x, -_fling_speed , _fling_speed)
		#velocity.x = clamp(velocity.x, -_fling_speed if _fling_speed > move_speed else -move_speed, _fling_speed if _fling_speed > move_speed else move_speed)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_jump()
	if Input.is_action_just_released("jump") and _get_gravity() == jump_gravity:
		velocity.y *= 0.3
	
	if _is_hooked:
		var to_hook: Vector2 = _hook_point - global_position
		var dist: float = to_hook.length()
		if dist > 5.0:
			var direction: Vector2 = to_hook.normalized()
			# Force scales linearly with distance (Hooke's law: F = k * x).
			var spring_force: Vector2 = direction * dist * hook_spring_strength
			# Damping reduces velocity along the pull direction to prevent oscillation.
			var damping_force: Vector2 = -velocity * hook_damping
			velocity += (spring_force + damping_force) * delta
			if velocity.y >= 0:
				velocity.y = 0
		else:
			_is_hooked = false
			_hook_point = Vector2.ZERO
			_hook_grace_timer = 0.5
			_fling_speed = velocity.x
	
	move_and_slide()


func _get_horizontal_input() -> float:
	var input := 0.0
	if Input.is_action_pressed("right") and not directions_currently_pressed.left_held:
		input = 1.0
		last_direction_angle = 0
		last_direction_pressed.emit(last_direction_angle)
		directions_currently_pressed.right_held = true
	elif Input.is_action_pressed("left") and not directions_currently_pressed.right_held:
		input = -1.0
		last_direction_angle = 180
		last_direction_pressed.emit(last_direction_angle)
		directions_currently_pressed.left_held = true
	
	if Input.is_action_just_released("right"):
		directions_currently_pressed.right_held = false
	if Input.is_action_just_released("left"):
		directions_currently_pressed.left_held = false
	
	return input



func _get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func _jump():
	velocity.y = jump_velocity


func _on_hook_hooked(hooked_position: Variant) -> void:
	_hook_point = hooked_position
	_is_hooked = true


func _on_hook_unhooked() -> void:
	_is_hooked = false
	_hook_point = Vector2.ZERO
	_hook_grace_timer = 0.5
	_fling_speed = velocity.x
