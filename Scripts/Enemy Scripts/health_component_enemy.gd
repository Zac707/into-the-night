extends Area2D


@export var max_health:= 2.0
@export var enemy: CharacterBody2D
@export var invulnerability_timer: Timer
@export var sprite: Sprite2D


var health: float
var invulnerable: bool = false
var knockback: Vector2
var mat 


func _ready():
	health = max_health
	mat = sprite.material as ShaderMaterial


func get_enemy_damage(attack : Attack):
	if invulnerable == false:
		health -= attack.attack_damage
		knockback = attack.knockback_force * attack.attack_direction
		
		invulnerable = true
		enemy.hurt = true
		invulnerability_timer.start()
		mat.set_shader_parameter("flash_active", true)
		
		if health <= 0:
			enemy.queue_free()


func _on_invulnerability_timer_timeout() -> void:
	mat.set_shader_parameter("flash_active", false)
	invulnerable = false
