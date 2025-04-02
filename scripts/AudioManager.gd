extends Node2D

@export var sound_effect_settings : Array[SoundEffectSettings]
var sound_effect_dict : Dictionary = {}

func _ready() -> void:
	for sound_effect_setting in sound_effect_settings:
		sound_effect_dict[sound_effect_setting.type] = sound_effect_setting


func play_2d_audio_at_location(location : Vector2, type : SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_2d_audio := AudioStreamPlayer2D.new()
			add_child(new_2d_audio)
			
			new_2d_audio.position = location
			new_2d_audio.stream = sound_effect_setting.sound_effect
			new_2d_audio.volume_db = sound_effect_setting.volume
			new_2d_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_2d_audio.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_2d_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_2d_audio.finished.connect(new_2d_audio.queue_free)
			
			new_2d_audio.play()
	else:
		push_error("Audio type parameter is not defined: ", type)


func play_audio_at_node(node : Node2D, type : SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_2d_audio := AudioStreamPlayer2D.new()
			node.add_child(new_2d_audio)
			
			new_2d_audio.stream = sound_effect_setting.sound_effect
			new_2d_audio.volume_db = sound_effect_setting.volume
			new_2d_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_2d_audio.pitch_scale += randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_2d_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_2d_audio.finished.connect(new_2d_audio.queue_free)
			
			new_2d_audio.play()
	else:
		push_error("Audio type parameter is not defined: ", type)


func stop_audio_at_node(node : Node2D, type : SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting : SoundEffectSettings = sound_effect_dict[type]
		for child in node.get_children():
			if child is AudioStreamPlayer2D:
				if child.stream == sound_effect_setting.sound_effect:
					child.finished.emit()
	else:
		push_error("Audio type parameter is not defined: ", type)
