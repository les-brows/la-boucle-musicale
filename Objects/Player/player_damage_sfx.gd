extends AudioStreamPlayer

var want_to_play: bool = false

func _init() -> void:
	Globals.player_damage.connect(_on_player_damage)
	Globals.beat_launched.connect(_on_beat_launched)

func _on_player_damage(_health):
	want_to_play = true

func _on_beat_launched(_beat: int):
	if(want_to_play):
		want_to_play = false
		play()
