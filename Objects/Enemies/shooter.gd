extends Enemy

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0

var shoot_partition: Partition

func _init() -> void:
	super()
	var note1: Note = Note.new(0, 0, 0)
	var note2: Note = Note.new(1, 0, 0)
	var note3: Note = Note.new(3, 0, 0)
	var note4: Note = Note.new(5, 0, -0.1)
	var note5: Note = Note.new(6, 0, 0)
	var list_notes: Array[Note] = [note1, note2, note3, note4, note5]
	shoot_partition = Partition.new(4, 8, list_notes)


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


func _on_beat_launched(num_beat: int) -> void:
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
		var note = shoot_partition.get_curr_note()
		$InstrumentPlayer.pitch_scale = 1.0 + note.pitch
		$InstrumentPlayer.play()
		print("Boing ", note.beat_number, " ", note.pitch)
