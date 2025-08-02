extends Enemy

var shooter_projectile_preload = preload("res://Objects/Projectiles/ShooterProjectile.tscn");
var shooter_projectile_speed: float = 1000

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0

var shoot_partition: Partition

func _init() -> void:
	super()
	var list_notes: Array[Note] = [Note.new(0, 0, 3), Note.new(3, 0, -2), Note.new(5, 0, -2), 
								   Note.new(7, 0, -2), Note.new(8, 0, 3), Note.new(11, 0, -2),
								   Note.new(13, 0, -2), Note.new(14, 0, 4), Note.new(16, 0, 3),
								   Note.new(16 + 3, 0, -2), Note.new(16 + 5, 0, -2), Note.new(16 + 7, 0, -2),
								   Note.new(16 + 8, 0, 3), Note.new(16 + 11, 0, 6), Note.new(16 + 13, 0, 4),
								   Note.new(16 + 14, 0, 1)]
	shoot_partition = Partition.new(4, 32, list_notes)
	shoot_partition.remove_random_notes(0.7)

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
		$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
		$InstrumentPlayer.play()
		shoot_projectile(Vector2(-1, 0))

func shoot_projectile(target_direction: Vector2):
	var shooter_projectile = shooter_projectile_preload.instantiate()
	shooter_projectile.set_position(position)
	# May be used when ennemies move
	var linear_velocity = Vector2.ZERO 
	shooter_projectile.set_velocity(linear_velocity + target_direction.normalized() * shooter_projectile_speed )
	get_parent().add_child(shooter_projectile)

	pass
