extends Node


var current_tilemap_bounds: Array[Vector2]
signal bounds_changed(bounds: Array[Vector2])


func change_tilemaps_bounds(bounds: Array[Vector2])-> void:
	current_tilemap_bounds = bounds
	bounds_changed.emit(current_tilemap_bounds)
