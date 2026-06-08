extends Area2D


@export var max_health:= 3.0
@export var player: CharacterBody2D
@export var invulnerability_timer: Timer

var health : float
var invulnerable = false

signal health_changed(player_hearts)


func _ready():
	health = max_health


func get_damage_player(attack : Attack):
	if invulnerable == false :
		health -= attack.attack_damage
		var knockback_direction = attack.attack_direction.direction_to(player.global_position)
		var knockback = attack.knockback_force * knockback_direction
		player.global_position += knockback
		player.move_and_slide() 
		invulnerable = true
		invulnerability_timer.start()
		#if health <= 0:
			#player.queue_free()


func _on_invulnerability_timer_timeout() -> void:
	invulnerable = false
