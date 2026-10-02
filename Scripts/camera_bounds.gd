extends Node2D


@export var boundary_order: int
@export var camera_manager: Node2D


func _enter_tree() -> void:
	if camera_manager.camera_setting == boundary_order:
		GlobalEventManager.change_tilemaps_bounds(get_tile_bounds())


func get_tile_bounds() -> Array[Vector2]:
	var children = get_children() 
	if children.is_empty():
		return []
	
	var first_pos = children[0].position
	var min_x = first_pos.x
	var max_x = first_pos.x
	var min_y = first_pos.y
	var max_y = first_pos.y
	
	for child in children:
		if child is Marker2D:
			var pos = child.position
			min_x = min(min_x, pos.x)
			max_x = max(max_x, pos.x)
			min_y = min(min_y, pos.y)
			max_y = max(max_y, pos.y)
	return [
		Vector2(min_x, 0),
		Vector2(max_x, 0),
		Vector2(0, max_y),
		Vector2(0, min_y)
	]
