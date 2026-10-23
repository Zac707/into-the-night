extends Node


func place_effects(effect, effect_pos, effect_scale, effect_duration):
	var instance = Sprite2D.new()
	instance.texture = effect
	instance.global_position = effect_pos
	instance.scale = effect_scale
	get_tree().current_scene.add_child(instance)
	
	await get_tree().create_timer(effect_duration).timeout
	instance.queue_free()
