extends HBoxContainer


@export var heart_scene: PackedScene

var max_hearts: int
var hearts: Array[Node] = []
var current_health: int = 0


func _ready() -> void:
	max_hearts = PlayerGlobals.maximum_health
	setup(max_hearts)
	
	PlayerGlobals.health_changed.connect(update_hearts)


func setup(starting_hearts: int) -> void:
	for h in hearts:
		h.queue_free()
	hearts.clear()
	
	max_hearts = starting_hearts
	current_health = starting_hearts
	
	for i in max_hearts:
		var heart = heart_scene.instantiate()
		add_child(heart)
		hearts.append(heart)


func update_hearts(new_health: int) -> void:
	new_health = clamp(new_health, 0, max_hearts)
	
	if new_health > current_health:
		for i in range(current_health, new_health):
			hearts[i].set_fill(true) # animated gain
	elif new_health < current_health:
		for i in range(new_health, current_health):
			hearts[i].set_fill(false) # animated lose
	
	current_health = new_health
