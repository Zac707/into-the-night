extends StateEnemy


class_name EnemyHurt


var actionable: bool = false


func enter():
	enemy.velocity = enemy.health_component.knockback
	enemy.velocity.y = -80
	enemy.animation_player.play("Hurt")


func exit():
	enemy.hurt = false
	actionable = false


func update(_delta: float):
	enemy.velocity.y += enemy.gravity * _delta
	
	evaluate_transitions()


func physics_update(_delta: float):
	pass


func evaluate_transitions():
	if actionable == true:
		if enemy.is_on_floor():
			transitioned_state.emit(self, "EnemyIdle")
		else:
			transitioned_state.emit(self, "EnemyFall")


func on_animation_finished():
	enemy.velocity = Vector2.ZERO
	actionable = true
