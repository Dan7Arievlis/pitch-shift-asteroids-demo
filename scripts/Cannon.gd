extends Node2D

@onready var item_pool: ItemPool = $ItemPool
@onready var cooldown: Timer = $Cooldown

func shoot() -> void:
	if not cooldown.is_stopped():
		return
	cooldown.start()
	var bullet = item_pool.get_first_item()
	if bullet:
		bullet.position = global_position
		bullet.rotation = global_rotation
		bullet.summon()
