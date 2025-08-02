extends AudioStreamPlayer

const VOLUME_DB_DIFF = 12
const VOLUME_DB_DIFF_BAR = 6
var initial_volume_db: float = 0


func _init() -> void:
	initial_volume_db = volume_db

func _on_music_manager_beat_launched(num_beat: int) -> void:
	if(num_beat % Globals.BPM_SUBDIVISION == 0):
		if((num_beat / Globals.BPM_SUBDIVISION) % 4 ==0):
			volume_db = initial_volume_db
		else:
			volume_db = initial_volume_db - VOLUME_DB_DIFF_BAR
	else:
		volume_db = initial_volume_db - VOLUME_DB_DIFF
	play()
 
