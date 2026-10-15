# This and ShieldHandHurt are the only states accessible once the shield has been removed.
extends StateShieldHand


class_name ShieldHandPanic


var hover_direction: float = 1.0
var hover_timer: float = 0.0


func enter():
	if enemy.last_horizontal_direction == 1.0:
		enemy.animation_player.play("Panic")
	else:
		enemy.animation_player.play("Left_Panic")
	
	enemy.animation_player.play("sweat")
	
	evaluate_transitions()


func exit():
	enemy.animation_player.play("emoticons_disabled")


func update(_delta: float):
	evaluate_transitions()


func physics_update(_delta: float):
	hover_timer -= _delta
	if hover_timer <= 0.0:
		hover_direction *= -1.0
		hover_timer = randf_range(0.5, 1.0)
	
	enemy.velocity.x += hover_direction * enemy.move_speed * enemy.acceleration * _delta
	enemy.velocity.x = clamp(enemy.velocity.x, -enemy.move_speed, enemy.move_speed)


func evaluate_transitions():
	if enemy.hurt == true:
		transitioned_state.emit(self, "ShieldHandHurt")
	elif enemy.is_on_floor() == false:
		transitioned_state.emit(self, "ShieldHandFall")
