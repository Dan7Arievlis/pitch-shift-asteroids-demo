class_name AudioPlayer

static func play(audio : AudioStreamPlayer2D, pitch_delta : float = 0.0, from_position : float = 0.0):
	if pitch_delta == 0:
		audio.play(from_position)
		return
	
	audio.play_audio(pitch_delta, from_position)


static func stop(audio : AudioStreamPlayer2D):
	audio.stop()
