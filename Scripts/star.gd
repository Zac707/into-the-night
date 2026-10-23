extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		PlayerGlobals.collected_stars += 1
		PlayerGlobals.star_collected.emit(1)
		queue_free()
