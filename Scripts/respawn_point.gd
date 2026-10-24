extends Area2D


signal new_respawn_point_entered


func _ready() -> void:
	new_respawn_point_entered.connect(PlayerRespawn.update_respawn_position)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		new_respawn_point_entered.emit(self.global_position)
