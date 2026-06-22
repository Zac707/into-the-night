class_name PlayerCamera extends Camera2D


func _ready() -> void:
	GlobalEventManager.bounds_changed.connect(update_limits)
	update_limits(GlobalEventManager.current_tilemap_bounds)


func update_limits(bounds: Array[Vector2])-> void:
	if bounds == []:
		return
	limit_left = bounds[0].x
	limit_top = bounds[0].y
	limit_right = bounds[1].x
	limit_bottom = bounds[1].y
	print(limit_left, limit_top, limit_right, limit_bottom)
