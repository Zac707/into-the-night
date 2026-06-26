class_name PlayerCamera extends Camera2D

# How long the transition takes (in seconds)
@export var transition_time: float = 1.0
# The easing/transition equations to make it look smooth
@export var trans_type: Tween.TransitionType = Tween.TRANS_CUBIC
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

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
	
	# If a previous transition is running, kill it to prevent conflicts
	if limit_tween and limit_tween.is_valid():
		limit_tween.kill()
		
	# Create a new parallel tween so all limits animate at the exact same time
	limit_tween = create_tween().set_parallel(true).set_trans(trans_type).set_ease(ease_type)
	
	# Animate each limit property from its current value to the new target value
	limit_tween.tween_property(self, "limit_left", bounds[0].x, transition_time)
	limit_tween.tween_property(self, "limit_right", bounds[1].x, transition_time)
	limit_tween.tween_property(self, "limit_bottom", bounds[2].y, transition_time)
	limit_tween.tween_property(self, "limit_top", bounds[3].y, transition_time)
