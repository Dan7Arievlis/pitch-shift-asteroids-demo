extends Node2D

@onready var item_pool: ItemPool = $ItemPool
const BIG_ASTEROID = preload("res://resources/big_asteroid.tres")

var offset := 160

func _ready() -> void:
	for item in item_pool.items.keys():
		item.connect("asteroid_destroyed", _on_asteroid_destroyed)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SHIFT):
		spawn()


func spawn():
	var point : Vector2 = Vector2.ZERO
	while get_viewport_rect().has_point(point):
		point = Vector2(randf_range(-offset, get_viewport_rect().size[0] + offset), randf_range(-offset, get_viewport_rect().size[1] + offset))
	
	var asteroid : Asteroid = item_pool.get_first_item()
	if asteroid:
		asteroid.asteroid_resource = BIG_ASTEROID
		asteroid.position = point
		var angle_to_player : float = point.angle_to_point(get_tree().get_first_node_in_group("Player").position)
		var angle_offset : float = deg_to_rad(10)
		
		asteroid.rotation = randf_range(angle_to_player - angle_offset, angle_to_player + angle_offset)
		asteroid.summon()


func _on_cooldown_timeout() -> void:
	spawn()


func _on_asteroid_destroyed(node : RigidBody2D, _position : Vector2, _linear_velocity : Vector2):
	if not node.asteroid_resource.next_asteroid:
		return
	for i in 2:
		var asteroid : Asteroid = item_pool.get_first_item()
		if asteroid:
			asteroid.asteroid_resource = node.asteroid_resource.next_asteroid
			asteroid.position = _position
			var angle_offset : float = deg_to_rad(10)
			
			asteroid.rotation = PI / 4 - (1 ^ i) * randf_range(node.rotation - angle_offset, node.rotation + angle_offset)
			asteroid.summon()
