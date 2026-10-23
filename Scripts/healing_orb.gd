extends Area2D


@export var healing_power: int = 1


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("heal_player"):
		area.heal_player(healing_power)
		self.queue_free()
