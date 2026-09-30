extends StateShieldHand


class_name ShieldHandDistance


@export var min_distance: float = 40.0
@export var max_distance: float = 60.0

var direction: float
var original_direction: float
var distance: float
var distance_to_player: Vector2
var max_distance_reached: bool = false
var time_until_approach: float = 3.0
var hover_direction: float = 1.0
var hover_timer: float = 0.0


func enter():
	original_direction = signf(enemy.player.global_position.x - enemy.global_position.x)
	enemy.last_horizontal_direction = original_direction
	
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Distance")
	else:
		enemy.animation_player.play("Left_Distance")
	
	evaluate_transitions()


func exit():
	max_distance_reached = false
	time_until_approach = 3.0
	hover_direction = 1.0
	hover_timer = 0.0


func update(_delta: float):
	distance = enemy.global_position.distance_to(enemy.player.global_position)
	var distance_x = enemy.player.global_position.x - enemy.global_position.x
	var distance_y = enemy.player.global_position.y - enemy.global_position.y
	if abs(distance_y) >= abs(distance_x) and distance_y < 0.0:
		distance_to_player = Vector2(0, signf(distance_y))
	else:
		distance_to_player = Vector2(signf(distance_x), 0)
	change_shield_position(distance_to_player)
	
	time_until_approach -= _delta
	
	evaluate_transitions()


func physics_update(_delta: float):
	if enemy.is_on_floor():
		if enemy.player != null:
			direction = signf(enemy.player.global_position.x - enemy.global_position.x)
			#check wether shieldhand should move towards or away fromplayer, or stay in place. Still needs to add animation to each separately
			if distance >= max_distance:
				max_distance_reached = true
			elif distance <= min_distance:
				enemy.velocity.x -= direction * enemy.move_speed * enemy.acceleration * _delta
				enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)
			else:
				hover(_delta)
		else:
			enemy.velocity.x = move_toward(enemy.velocity.x, 0.0, enemy.friction * enemy.move_speed * _delta)
	else:
		enemy.last_horizontal_direction = direction


func change_shield_position(shield_direction):
	shield.position = 16 * shield_direction
	if shield_direction.y != 0:
		shield.rotation = Vector2.UP.angle_to(shield_direction)
	
	enemy.last_shield_position = shield_direction


func hover(delta: float):
	hover_timer -= delta
	if hover_timer <= 0.0:
		hover_direction *= -1.0
		hover_timer = randf_range(0.2, 0.5)
	
	enemy.velocity.x += hover_direction * enemy.move_speed * enemy.acceleration * delta
	enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif enemy.defended == true:
		transitioned_state.emit(self, "ShieldHandDefend")
	elif enemy.velocity.x == 0 and enemy.is_on_floor() and enemy.player == null:
		transitioned_state.emit(self, "ShieldHandIdle")
	elif not enemy.is_on_floor():
		transitioned_state.emit(self, "ShieldHandFall")
	elif enemy.is_on_floor() and max_distance_reached == true:
		transitioned_state.emit(self, "ShieldHandApproach")
	elif enemy.is_on_floor() and time_until_approach <= 0.0:
		transitioned_state.emit(self, "ShieldHandApproach")
