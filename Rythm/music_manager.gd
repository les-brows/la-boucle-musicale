extends Node

func _ready() -> void:
	$Metronome.set_audio_node($Music)
