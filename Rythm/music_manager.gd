extends Node

signal beat_launched(num_beat: int)


func _on_metronome_beat_launched(num_beat: int) -> void:
	beat_launched.emit(num_beat)
