class_name Hookshot extends Sprite2D

@export var raycast: RayCast2D
@export var pivot: Node2D
@export var max_distance: float = 50.0

var distance: float = 50.0
var start_duration = 0.1
var return_duration = 0.3
var _hook_activated: bool = false
var _collision_found: bool = false
var _extending_hookshot: bool = false

signal hooked(hooked_position)
signal unhooked()
signal hook_sent(start_duration, return_duration)


func interpolate(length, duration):
	var tween_offset = create_tween()
	var tween_rect_h = create_tween()
	tween_offset.tween_property(self, "offset", Vector2(0, length / 2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(0, 0, 8, length), duration)


func fire() -> void:
	if _hook_activated:
		return
	hook_sent.emit(start_duration, return_duration)
	_hook_activated = true
	_extending_hookshot = true
	pivot.rotation_permitted = false
	
	await get_tree().create_timer(start_duration).timeout
	_extending_hookshot = false
	reverse_interpolate()
	await get_tree().create_timer(return_duration).timeout
	
	_hook_activated = false
	_collision_found = false
	pivot.rotation_permitted = true
	unhooked.emit()


func _process(delta: float) -> void:
	if _hook_activated == true and _collision_found == false:
		var hook_distance = check_collision()
		if _extending_hookshot == true:
			interpolate(hook_distance, start_duration)


func reverse_interpolate():
	if _collision_found == false:
		interpolate(0, return_duration)
		print("drawing hookshot back")
	else:
		var return_duration_scaled: float = return_duration * (distance / max_distance)
		interpolate(0, return_duration_scaled)


func check_collision():
	if raycast.is_colliding() and _collision_found == false:
		var collider = raycast.get_collider()
		_collision_found = true
		if collider.is_in_group("hook_area"):
			var collision_point = raycast.get_collision_point()
			distance = global_position.distance_to(collision_point)
			if region_rect.size.y >= distance:
				hooked.emit(collision_point)
				print("hook-point found")
				return distance
		# Colliding, but not a valid hook target — treat as a miss.
	_collision_found = false
	distance = max_distance
	return distance
