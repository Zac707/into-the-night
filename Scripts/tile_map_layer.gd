extends TileMapLayer


"""does not work properly. will instead be using sets of markers to transmit their positions and assign those as the bounds.
Will introduce marker sets, concisting of 4 markers. When camera boundaries need to switch to another box  an area2d will work as transition check to send out 
another signal from the global script to adapt the boundaries
func _ready() -> void:
	GlobalEventManager.change_tilemaps_bounds(get_tile_nounds())


func get_tile_nounds()-> Array[Vector2]:
	var bounds: Array[Vector2]
	bounds.append(Vector2(get_used_rect().position * rendering_quadrant_size))
	bounds.append(Vector2(get_used_rect().end * rendering_quadrant_size))
	return bounds"""
