extends CharacterBody2D

@export var _angular_speed : float = 0.07
@export var _angular_accel : float = 10.0
@export var thrust_speed : float = 100.0
@export var accel : float = 10.0
@export var friction : float = 10.0

@onready var cannon: Node2D = %Cannon
#@onready var boost: AudioStreamPlayer2D = $Boost
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var turn : float
var thrust : float
var angular_velocity : float = 0.0

func _unhandled_input(event: InputEvent) -> void:
	turn = Input.get_axis("move_left", "move_right")
	thrust = Input.is_action_pressed("move_forward")
	
	if event.is_action_pressed("shoot"):
		cannon.shoot()
	if event.is_action_pressed("move_forward"):
		animation_player.play("moving")
	if event.is_action_released("move_forward"):
		animation_player.play("idle")


func _physics_process(delta: float) -> void:
	rotation +=  _turn(delta)
	velocity = Vector2.RIGHT.rotated(rotation) * _speed_acceleration(thrust_speed, accel, friction, delta)
	
	move_and_slide()


func _turn(delta : float) -> float:
	angular_velocity = lerp(angular_velocity, _angular_speed * turn, _angular_accel * delta)
	return angular_velocity


func _speed_acceleration(speed : float, accel : float, friction : float, delta: float) -> float :
	if thrust:
		if speed - velocity.length() > 0.1:
			return lerp(velocity.length(), speed, accel * delta)
		else:
			return speed
	else:
		return lerp(velocity.length(), 0.0, friction * delta)


func loop_boost():
	AudioManager.play_audio_at_node(self, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_PLAYER_THRUST)

func stop_boost():
	AudioManager.stop_audio_at_node(self, SoundEffectSettings.SOUND_EFFECT_TYPE.ON_PLAYER_THRUST)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Asteroid"):
		call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
		
		await get_tree().create_timer(2).timeout
		get_tree().reload_current_scene()
