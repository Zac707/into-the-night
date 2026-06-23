extends Node2D


@export var camera_boxes: Array[Area2D]

var camera_setting: int = 1


func _ready() -> void:
	for box in camera_boxes:
		box.new_camera_boundaries.connect(change_boundaries)


func change_boundaries(new_boundaries):
	camera_setting = new_boundaries.boundary_order
	GlobalEventManager.change_tilemaps_bounds(new_boundaries.get_tile_bounds())
