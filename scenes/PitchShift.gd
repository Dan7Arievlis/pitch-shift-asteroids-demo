class_name PitchShift
extends AudioStreamPlayer2D

@onready var original_pitch = pitch_scale

var last_pitch : float

func play_audio(delta : float = 0.0, from_position : float = 0.0):
	if delta >= original_pitch:
		play(from_position)
		return
		
	_get_random(delta)
	while abs(pitch_scale - last_pitch) < .1:
		_get_random(delta)
	
	last_pitch = pitch_scale
	play(from_position)


func _get_random(delta):
	randomize()
	pitch_scale = original_pitch + randf_range(-delta, delta)
