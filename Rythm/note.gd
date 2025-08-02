extends Object

class_name Note

var beat_number: int = 0
var action: int = 0
var pitch: int = 0

func _init(init_beat_number: int, init_action: int, init_pitch: int):
	action = init_action
	beat_number = init_beat_number
	pitch = init_pitch
