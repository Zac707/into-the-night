extends Area2D


@export var max_health:= 2.0
@export var enemy: CharacterBody2D
@export var sprite: Sprite2D
@export var flash_timer: Timer
@export var shield: Area2D

var health: float
var knockback: Vector2
var mat 


func _ready():
	health = max_health
	mat = sprite.material as ShaderMaterial


func get_enemy_damage(attack : Attack):
	#await get_tree().process_frame
	
	if enemy.defended == false:
		health -= attack.attack_damage
		knockback = attack.knockback_force * attack.attack_direction
		
		enemy.hurt = true
		flash_timer.start()
		mat.set_shader_parameter("flash_amount", 1.0)
	else:
		knockback = attack.knockback_force/3 * attack.attack_direction
	
	if health <= 0:
		enemy.queue_free()


func _on_flash_timer_timeout() -> void:
	mat.set_shader_parameter("flash_amount", 0.0)
