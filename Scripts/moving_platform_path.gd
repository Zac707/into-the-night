@tool
extends Path2D


@export var speed := 50.0  
@export var follow: PathFollow2D 

var _dist := 0.0
var _dir := 1.0


func _process(_delta: float) -> void:
	if not Engine.is_editor_hint() or curve == null:
		return
	
	for i in curve.point_count:
		if curve.get_point_in(i) != Vector2.ZERO:
			curve.set_point_in(i, Vector2.ZERO)
		if curve.get_point_out(i) != Vector2.ZERO:
			curve.set_point_out(i, Vector2.ZERO)
	
	for i in range(1, curve.point_count):
		var prev := curve.get_point_position(i - 1)
		var p := curve.get_point_position(i)
		var d := p - prev
		var target := prev + (Vector2(d.x, 0.0) if absf(d.x) >= absf(d.y) else Vector2(0.0, d.y))
		if p != target:
			curve.set_point_position(i, target)
		i += 1



func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or curve == null:
		return
	var length := curve.get_baked_length()
	if length <= 0.0:
		return
	_dist += speed * _dir * delta
	if _dist >= length:
		_dist = length
		_dir = -1.0
	elif _dist <= 0.0:
		_dist = 0.0
		_dir = 1.0
	follow.progress = _dist
