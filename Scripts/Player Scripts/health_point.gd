extends Control


@export var animation_player: AnimationPlayer

var is_filled: bool = true


func set_fill(value: bool):
	if value == is_filled:
		return
	else:
		is_filled = value
		
	if is_filled == true:
		animation_player.play("heart_gained")
	else:
		animation_player.play("heart_lost")
