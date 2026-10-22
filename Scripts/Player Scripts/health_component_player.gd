extends Area2D


@export var player: CharacterBody2D
@export var sprite: Sprite2D
@export var invulnerability_timer: Timer

var invulnerable: bool = false
var knockback: Vector2
var mat 


func _ready():
	PlayerGlobals.current_health = PlayerGlobals.maximum_health
	mat = sprite.material as ShaderMaterial


func get_player_damage(attack : Attack):
	if invulnerable == false :
		PlayerGlobals.current_health -= attack.attack_damage
		knockback = attack.knockback_force * attack.attack_direction
		
		player.hurt = true
		invulnerable = true
		invulnerability_timer.start()
		PlayerGlobals.health_changed.emit(PlayerGlobals.current_health)
		mat.set_shader_parameter("flash_active", true)
	
		if PlayerGlobals.current_health <= 0:
			player.queue_free()


func heal_player(heal_amount):
	if PlayerGlobals.current_health < PlayerGlobals.maximum_health:
		PlayerGlobals.current_health += heal_amount
		PlayerGlobals.health_changed.emit(PlayerGlobals.current_health)


func _on_invulnerability_timer_timeout() -> void:
	invulnerable = false
	mat.set_shader_parameter("flash_active", false)
	
	for area in get_overlapping_areas():
		if area.has_method("deal_damage"):
			area.deal_damage(self)
