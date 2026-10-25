class_name PlayerCamera extends Camera2D

# How long the transition takes (in seconds)
@export var transition_time: float = 1.0
# The easing/transition equations to make it look smooth
@export var trans_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

var offset_tween: Tween
var limit_tween: Tween

func _ready() -> void:
	GlobalEventManager.bounds_changed.connect(update_limits)
	# Snap instantly on room load so the game starts correctly
	update_limits_instant(GlobalEventManager.current_tilemap_bounds)


func update_limits_instant(bounds: Array[Vector2]) -> void:
	if bounds.is_empty(): 
		return
	limit_left = bounds[0].x 
	limit_right = bounds[1].x 
	limit_bottom = bounds[2].y 
	limit_top = bounds[3].y 


func update_limits(bounds: Array[Vector2]) -> void:
	if bounds.is_empty():
		return
	
	var old_center := get_screen_center_position()
	update_limits_instant(bounds)
	force_update_scroll()
	var new_center := get_screen_center_position()
	
	if offset_tween and offset_tween.is_valid():
		offset_tween.kill()
	
	# Cancel out the jump caused by the new limits, then ease back to zero
	offset += old_center - new_center
	offset_tween = create_tween().set_trans(trans_type).set_ease(ease_type)
	offset_tween.tween_property(self, "offset", Vector2.ZERO, transition_time)
