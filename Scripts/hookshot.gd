extends Sprite2D

@export var raycast: RayCast2D
@export var pivot: Node2D
@export var max_distance: float = 50.0

var distance: float = 50.0
var start_duration = 0.1
var return_duration = 0.5
var _hook_activated = false

signal hooked(hooked_position)
signal unhooked()


func interpolate(length, duration):
	var tween_offset = create_tween()
	var tween_rect_h = create_tween()
	tween_offset.tween_property(self, "offset", Vector2(0, length / 2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(0, 0, 8, length), duration)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook_test") and not _hook_activated:
		_hook_activated = true
		pivot.rotation_permitted = false
		interpolate(max_distance, start_duration)
		await get_tree().create_timer(start_duration).timeout
		check_collision()
		reverse_interpolate()
		await get_tree().create_timer(return_duration).timeout
		_hook_activated = false
		pivot.rotation_permitted = true
		unhooked.emit()


func reverse_interpolate():
	interpolate(0, return_duration)


func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("hook_area"):
			var collision_point = raycast.get_collision_point()
			distance = global_position.distance_to(collision_point)
			hooked.emit(collision_point)
			print("hook-point found")
			return distance
		# Colliding, but not a valid hook target — treat as a miss.
	distance = max_distance
	return distance
