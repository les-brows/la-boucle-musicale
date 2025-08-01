extends AudioStreamPlayer2D


func _on_metronome_beat_launched(num_beat: int) -> void:
	play()
	print(num_beat)
