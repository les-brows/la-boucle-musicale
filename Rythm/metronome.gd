extends Node

var last_beat: int = 0
var next_beat_position: float = 60.0 / Globals.BPM
var seconds_elapsed: float = 0.0
var time_start: float = 0.0

var start_metronome: bool = false
var last_playback_pos: float = -1.0
var num_loop: int = 0

var audio_player: AudioStreamPlayer = null
var stream_length_sec: float = 0

func _init() -> void:
	pass

func set_audio_node(_audio_player: AudioStreamPlayer):
	audio_player = _audio_player
	print(audio_player)
	stream_length_sec = audio_player.stream.get_length()
	time_start = wrap_get_playback_position()
	last_beat = 0
	start_metronome = true

func _process(_delta: float) -> void:
	if(start_metronome):
		seconds_elapsed = wrap_get_playback_position() - time_start
		while(next_beat_position < seconds_elapsed):
			Globals.beat_launched.emit(last_beat)
			last_beat += 1
			next_beat_position = last_beat *  60.0 / Globals.BPM

func wrap_get_playback_position() -> float:
	var playback_pos: float = audio_player.get_playback_position()
	if(playback_pos < last_playback_pos):
		num_loop+=1
	last_playback_pos = playback_pos
	return num_loop * stream_length_sec + playback_pos
