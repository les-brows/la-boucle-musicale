extends Enemy

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0


func _process(delta: float) -> void:
	if(boing_state > 0):
		if(boing_state < NB_SECONDS_BOING_RECOVER):
			scale -= Vector2.ONE * delta / NB_SECONDS_BOING_RECOVER * MAX_HEIGHT_BOING
			pass
		else:
			scale += Vector2.ONE * delta / NB_SECONDS_BOING_JUMP * MAX_HEIGHT_BOING
			pass
	else:
		scale =  Vector2.ONE
	boing_state -= delta


func _on_music_manager_beat_launched(num_beat: int) -> void:
	if(num_beat % 4 == 0):
		boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
		print("Boing")
