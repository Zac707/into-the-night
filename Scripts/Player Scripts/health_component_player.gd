extends Area2D


@export var max_health:= 3.0
@export var player: CharacterBody2D
@export var invulnerability_timer: Timer

var health : float
var invulnerable = false
var knockback

signal health_changed(player_hearts)


func _ready():
	health = max_health


func get_player_damage(attack : Attack):
	if invulnerable == false :
		health -= attack.attack_damage
		knockback = attack.knockback_force * attack.attack_direction
		
		player.hurt = true
		invulnerable = true
		invulnerability_timer.start()
		if health <= 0:
			player.queue_free()


func _on_invulnerability_timer_timeout() -> void:
	invulnerable = false
