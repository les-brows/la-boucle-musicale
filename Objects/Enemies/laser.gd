extends Enemy



var shoot_partition: Partition
var on_screen: bool = false

func _init() -> void:
	super()
	var list_notes: Array[Note] = [Note.new(0, 0, 0), Note.new(2, 0, 0), Note.new(5, 0, 0),
								   Note.new(8, 0, 0), Note.new(16, 0, 0), Note.new(18, 0, 0),
								   Note.new(21, 0, 0), Note.new(23, 0, 0), Note.new(24, 0, 0),
								   Note.new(28, 0, 0)]
	shoot_partition = Partition.new(4, 32, list_notes)
	shoot_partition.remove_random_notes(0.7)

func _on_beat_launched(num_beat: int) -> void:
	if(!on_screen):
		return
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		#boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
		var note = shoot_partition.get_curr_note()
		$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
		$InstrumentPlayer.play()
		#if(player == null):
			#shoot_projectile(Vector2(-1, 0))
		#else :
			#shoot_projectile(player.global_position - global_position)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
