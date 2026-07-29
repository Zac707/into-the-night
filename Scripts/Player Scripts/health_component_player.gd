extends Area2D


@export var player: CharacterBody2D
@export var invulnerability_timer: Timer

var invulnerable: bool = false
var knockback: Vector2


func _ready():
	PlayerGlobals.current_health = PlayerGlobals.maximum_health


func get_player_damage(attack : Attack):
	if invulnerable == false :
		PlayerGlobals.current_health -= attack.attack_damage
		knockback = attack.knockback_force * attack.attack_direction
		
		player.hurt = true
		invulnerable = true
		invulnerability_timer.start()
		PlayerGlobals.health_changed.emit(PlayerGlobals.current_health)
		
		if PlayerGlobals.current_health <= 0:
			player.queue_free()


func _on_invulnerability_timer_timeout() -> void:
	invulnerable = false
