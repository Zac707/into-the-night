@tool
extends AnimatableBody2D

const TILE := 16

@export var left_tex: Texture2D
@export var mid_tex: Texture2D
@export var right_tex: Texture2D
@export var col: CollisionShape2D 


func _ready() -> void:
	queue_redraw()


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	var rect := col.shape as RectangleShape2D
	if rect == null:
		return
	var tiles := maxi(roundi(rect.size.x / TILE), 2)
	var snapped_size := Vector2(tiles * TILE, TILE)
	if rect.size != snapped_size:
		rect.size = snapped_size
	queue_redraw()


func _draw() -> void:
	var rect := col.shape as RectangleShape2D
	if rect == null or left_tex == null or mid_tex == null or right_tex == null:
		return
	var tiles := int(rect.size.x / TILE)
	var origin := col.position - rect.size / 2.0
	draw_texture(left_tex, origin)
	for i in range(1, tiles - 1):
		draw_texture(mid_tex, origin + Vector2(i * TILE, 0))
	draw_texture(right_tex, origin + Vector2((tiles - 1) * TILE, 0))
