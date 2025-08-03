extends Node


var shooter_projectile_preload = preload("res://Objects/Projectiles/PlayerProjectile.tscn");
var shooter_projectile_speed: float = 1000
var isDead=false 

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0

var shoot_partition: Partition
var shootDir = Vector2(0,0)
var positionPlayer = Vector2(0,0)
var wantShoot =0
var nb_shoot :int

func _on_player_shoot():
	wantShoot=nb_shoot
	
	
func _on_player_direction_shoot (shoot_x:float , shoot_y:float):
	shootDir.x = shoot_x 
	if shootDir.length() > 1:
		shootDir = shootDir.normalized()
	
	shootDir.y = shoot_y
	if shootDir.length() > 1:
		shootDir = shootDir.normalized()

func _init() -> void:
	Globals.beat_launched.connect(_on_beat_launched)
	generate_partition(Globals.LOOP_COUNT)

func generate_partition(loop_count: int):
	match loop_count:
		0:
			var list_notes: Array[Note] = [Note.new(0, 0, 3),Note.new(4, 0, -2)]
			nb_shoot= list_notes.size()
			shoot_partition = Partition.new(8, 8, list_notes)
		1:
			var list_notes: Array[Note] = [Note.new(0, 0, 3),Note.new(4, 0, -2), 
										   Note.new(7, 0, -2)]
			nb_shoot= list_notes.size()
			shoot_partition = Partition.new(8, 8, list_notes)
		_:
			var list_notes: Array[Note] = [Note.new(0, 0, 3),Note.new(4, 0, -2), 
										   Note.new(7, 0, -2), Note.new(8, 0, 3)]
			nb_shoot= list_notes.size()
			shoot_partition = Partition.new(8, 8, list_notes)
			pass

func _process(delta: float) -> void:
	if(boing_state > 0):
		if(boing_state < NB_SECONDS_BOING_RECOVER):
			#scale -= Vector2.ONE * delta / NB_SECONDS_BOING_RECOVER * MAX_HEIGHT_BOING
			pass
		else:
			#scale += Vector2.ONE * delta / NB_SECONDS_BOING_JUMP * MAX_HEIGHT_BOING
			pass
	else:
		#scale =  Vector2.ONE
		pass
	boing_state -= delta


func _on_beat_launched(num_beat: int) -> void:
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		if(shootDir!=Vector2.ZERO && !isDead ):
		
			wantShoot-=1
			boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
			var note = shoot_partition.get_curr_note()
			$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
			$InstrumentPlayer.play()
			shoot_projectile(shootDir)

func shoot_projectile(target_direction: Vector2):
		var player_projectile = shooter_projectile_preload.instantiate()
		var copyposition=get_parent().position
		# May be used when ennemies move
		var linear_velocity = Vector2.ZERO 
		
		get_parent().get_parent().add_child(player_projectile)
		player_projectile.set_position( copyposition)
		player_projectile.set_velocity(linear_velocity + target_direction.normalized() * shooter_projectile_speed )
