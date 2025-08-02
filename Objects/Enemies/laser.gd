extends Enemy

var laser_projectile_preload = preload("res://Objects/Projectiles/LaserProjectile.tscn");
var laser_projectile_speed: float = 1000
var laser_angular_speed: float = 1.5

var shoot_partition: Partition
var on_screen: bool = false

const NB_SECONDS_CHARGE_INVISIBLE: float = 0.5
const NB_SECONDS_CHARGE_RECOVER: float = 0.25
var charge_state: float = 0

func _init() -> void:
	super()
	var list_notes: Array[Note] = [Note.new(0, 0, 0), Note.new(2, 0, 0), Note.new(5, 0, 0),
								   Note.new(8, 0, 0), Note.new(16, 0, 0), Note.new(18, 0, 0),
								   Note.new(21, 0, 0), Note.new(23, 0, 0), Note.new(24, 0, 0),
								   Note.new(28, 0, 0)]
	shoot_partition = Partition.new(4, 32, list_notes)
	shoot_partition.remove_random_notes(0.6)
	shoot_partition.force_minimal_time_between_notes(8)

func _ready() -> void:
	$Preshot.rotation = randf_range(0, 2 * PI)

func _process(delta: float) -> void:
	$Preshot.rotation += delta * laser_angular_speed
	if(charge_state > 0):
		if(charge_state < NB_SECONDS_CHARGE_RECOVER):
			$Preshot.self_modulate.a = (NB_SECONDS_CHARGE_RECOVER - charge_state) / NB_SECONDS_CHARGE_RECOVER
		else:
			$Preshot.self_modulate.a = 0
	else:
		$Preshot.self_modulate.a = 1
	charge_state -= delta

func _on_beat_launched(num_beat: int) -> void:
	if(!on_screen):
		return
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		charge_state = NB_SECONDS_CHARGE_INVISIBLE
		var note = shoot_partition.get_curr_note()
		$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
		$InstrumentPlayer.play()
		shoot_laser()

func shoot_laser():
	var laser_projectile: Projectile = laser_projectile_preload.instantiate()
	laser_projectile.set_position(position)
	laser_projectile.rotation = $Preshot.rotation
	# May be used when ennemies move
	laser_projectile.set_velocity(Vector2.from_angle($Preshot.rotation) * 0.0001)
	get_parent().add_child(laser_projectile)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false
