extends Node2D

@onready var item_pool: ItemPool = $ItemPool
@onready var cooldown: Timer = $Cooldown

const LASER_SHOOT = preload("res://assets/audio/sfx/Laser_Shoot.wav")

func shoot() -> void:
	if not cooldown.is_stopped():
		return
	cooldown.start()
	AudioManager.play_2d_audio_at_location(position, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_CANNON_FIRED)
	var bullet = item_pool.get_first_item()
	if bullet:
		bullet.position = global_position
		bullet.rotation = global_rotation
		bullet.summon()
