class_name Asteroid
extends RigidBody2D

@export var asteroid_resource : AsteroidResource
@export var max_ttl : float = 10

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var explosion: PitchShift = $Explosion

const EXPLOSION = preload("res://assets/audio/sfx/Explosion.wav")

var speed : float

signal availability_changed(node : RigidBody2D, available : bool)
signal asteroid_destroyed(node : RigidBody2D, position : Vector2, linear_velocity : Vector2)

func summon():
	_enable(true)
	
	var w = asteroid_resource.sprite_position.size[0]
	sprite_2d.region_rect = asteroid_resource.sprite_position
	sprite_2d.region_rect.position.x = [0, w, w * 2].pick_random()
	
	collision_shape_2d.shape = asteroid_resource.collision_shape
	hitbox.shape = asteroid_resource.collision_shape
	
	speed = randf_range(asteroid_resource.min_speed, asteroid_resource.max_speed)
	linear_velocity = Vector2.RIGHT.rotated(rotation) * speed


func _on_hitbox_area_entered(area: Area2D) -> void:
	AudioPlayer.play(explosion, 0.5)
	_enable_collision(false)
	asteroid_destroyed.emit(self, position, linear_velocity)
	await explosion.finished
	_enable(false)


func _enable_collision(value : bool):
	sprite_2d.visible = value
	call_deferred("set_collision_layer_value", 2, value)
	hitbox.set_deferred("disabled", not value)


func _enable(value : bool) -> void:
	visible = value
	_enable_collision(value)
	call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED)
	availability_changed.emit(self, not value)


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	_enable(false)
