extends Node2D

@onready var item_pool: ItemPool = $ItemPool
@onready var cooldown: Timer = $Cooldown
@onready var laser_shoot: PitchShift = $LaserShoot

const LASER_SHOOT = preload("res://assets/audio/sfx/Laser_Shoot.wav")

func shoot() -> void:
	if not cooldown.is_stopped():
		return
	cooldown.start()
	AudioPlayer.play(laser_shoot, 0.3)
	var bullet = item_pool.get_first_item()
	if bullet:
		bullet.position = global_position
		bullet.rotation = global_rotation
		bullet.summon()
