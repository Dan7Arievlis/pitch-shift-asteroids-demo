extends Area2D

@export var speed : float = 200
@export var max_ttl : float = 3

@onready var sprite_2d: Sprite2D = $Sprite2D

const SMALL_BULLET : Rect2 = Rect2(448, 288, 32, 32)
const BIG_BULLET : Rect2 = Rect2(480, 288, 32, 32)

var ttl : float

signal availability_changed(node : Area2D, available : bool)

func _ready() -> void:
	sprite_2d.region_rect = [SMALL_BULLET, BIG_BULLET].pick_random()


func _process(delta: float) -> void:
	ttl -= delta
	if ttl < 0:
		_enable(false)


func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta


func summon():
	_enable(true)
	ttl = max_ttl


func _enable(value : bool) -> void:
	monitorable = value
	monitoring = value
	visible = value
	process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
	availability_changed.emit(self, not value)


func _on_area_entered(area: Area2D) -> void:
	call_deferred("_enable", false)
