extends Node

signal beat_launched(num_beat: int)

var last_beat: int = 0
var next_beat_position: float = 60.0 / Globals.BPM
var seconds_elapsed: float = 0.0
var time_start: float = 0.0

func _init() -> void:
	time_start = Time.get_unix_time_from_system()
	last_beat = 0.0

func _process(delta: float) -> void:
	seconds_elapsed = Time.get_unix_time_from_system() - time_start
	while(next_beat_position < seconds_elapsed):
		print("ON EST AU BEAT %d à %f secondes" % [last_beat, seconds_elapsed])
		beat_launched.emit(last_beat)
		last_beat += 1
		next_beat_position = last_beat *  60.0 / Globals.BPM
