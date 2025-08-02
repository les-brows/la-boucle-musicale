extends AudioStreamPlayer

const VOLUME_DB_DIFF = 12
const VOLUME_DB_DIFF_BAR = 6
var initial_volume_db: float = 0


func _init() -> void:
	Globals.beat_launched.connect(_on_beat_launched)
	initial_volume_db = volume_db

func _on_beat_launched(num_beat: int) -> void:
	if(num_beat % Globals.BPM_SUBDIVISION == 0):
		if(int(num_beat / float(Globals.BPM_SUBDIVISION)) % 4 ==0):
			volume_db = initial_volume_db
		else:
			volume_db = initial_volume_db - VOLUME_DB_DIFF_BAR
	else:
		volume_db = initial_volume_db - VOLUME_DB_DIFF
	play()
 
