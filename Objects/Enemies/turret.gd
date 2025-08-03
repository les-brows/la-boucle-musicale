extends Enemy

var shooter_projectile_preload = preload("res://Objects/Projectiles/TurretProjectile.tscn");
var shooter_projectile_speed: float = 500

var rotationBullet=0;
var turret_angular_speed=15;
var hasRotationBullet=true

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0
var shoot_partition: Partition
var nb_projectile_shoot =15

var on_screen: bool = false
func _init() -> void:
	super()
	generate_partition(Globals.LOOP_COUNT,0)


func generate_partition(loop_count: int, _pattern_variant: int):
	match loop_count:
		0:
			var list_notes: Array[Note] = [Note.new(10, 0, 1), Note.new(11, 0, 1), Note.new(14, 0, -2) ]
			shoot_partition = Partition.new(4, 16, list_notes)
		3:
			var list_notes: Array[Note] = [Note.new(0, 0, 0), Note.new(4, 0, 7), Note.new(5, 0, 7),
										   Note.new(6, 0, 7), Note.new(8, 0, 0), Note.new(11, 0, 8),
										   Note.new(14, 0, 8), Note.new(16, 0, 0), Note.new(20, 0, 7),
										   Note.new(21, 0, 7), Note.new(22, 0, 5), Note.new(24, 0, 7),
										   Note.new(26, 0, 8), Note.new(27, 0, 7), Note.new(29, 0, 5),
										   Note.new(30, 0, 3),
										   Note.new(32, 0, 0), Note.new(32 + 4, 0, 7), Note.new(32 + 5, 0, 7),
										   Note.new(32 + 6, 0, 7), Note.new(32 + 8, 0, 0), Note.new(32 + 11, 0, 8),
										   Note.new(32 + 14, 0, 8), Note.new(32 + 16, 0, 3), Note.new(32 + 20, 0, 10),
										   Note.new(32 + 21, 0, 10), Note.new(32 + 22, 0, 8), Note.new(32 + 24, 0, 7),
										   Note.new(32 + 26, 0, 5), Note.new(32 + 27, 0, 3), Note.new(32 + 29, 0, 5),
										   Note.new(32 + 30, 0, 7)]
			shoot_partition = Partition.new(4, 64, list_notes)
			turret_angular_speed = 20
			nb_projectile_shoot = 8
			shooter_projectile_speed = 400
			shoot_partition.remove_random_notes(0.4)
		4:
			var list_notes: Array[Note] = [Note.new(0, 0, 0), Note.new(2, 0, 7), Note.new(4, 0, 5),
										   Note.new(7, 0, 3), Note.new(9, 0, 2), Note.new(11, 0, 0),
										   Note.new(12, 0, -2), Note.new(14, 0, 2), Note.new(16, 0, 0),
										   Note.new(18, 0, 7), Note.new(20, 0, 9), Note.new(21, 0, 5),
										   Note.new(23, 0, 5), Note.new(25, 0, 9), Note.new(27, 0, 5),
										   Note.new(28, 0, 7),
										   Note.new(32, 0, 0), Note.new(32 + 2, 0, 7), Note.new(32 + 4, 0, 5),
										   Note.new(32 + 7, 0, 3), Note.new(32 + 9, 0, 5), Note.new(32 + 11, 0, 3),
										   Note.new(32 + 12, 0, 2), Note.new(32 + 14, 0, 0), Note.new(32 + 16, 0, 0),
										   Note.new(32 + 18, 0, -5), Note.new(32 + 20, 0, -5), Note.new(32 + 21, 0, 0),
										   Note.new(32 + 23, 0, 2), Note.new(32 + 25, 0, 3), Note.new(32 + 27, 0, 2),
										   Note.new(32 + 28, 0, 0)]
			shoot_partition = Partition.new(4, 64, list_notes)
		_:
			var list_notes: Array[Note] = [Note.new(0, 0, 3), Note.new(3, 0, -2), Note.new(5, 0, -2), 
										   Note.new(7, 0, -2), Note.new(8, 0, 3), Note.new(11, 0, -2),
										   Note.new(13, 0, -2), Note.new(14, 0, 4), Note.new(16, 0, 3),
										   Note.new(16 + 3, 0, -2), Note.new(16 + 5, 0, -2), Note.new(16 + 7, 0, -2),
										   Note.new(16 + 8, 0, 3), Note.new(16 + 11, 0, 6), Note.new(16 + 13, 0, 4),
										   Note.new(16 + 14, 0, 1)]
			shoot_partition = Partition.new(4, 32, list_notes)
			shoot_partition.remove_random_notes(0.7)
			pass
func _ready() -> void:
	rotationBullet = randf_range(0, 2 * PI)


	
func _process(delta: float) -> void:
	rotationBullet += delta * turret_angular_speed
	if(boing_state > 0):
		if(boing_state < NB_SECONDS_BOING_RECOVER):
			spriteEnemy.get_parent().scale -= Vector2.ONE * delta / NB_SECONDS_BOING_RECOVER * MAX_HEIGHT_BOING
			pass
		else:
			spriteEnemy.get_parent().scale += Vector2.ONE * delta / NB_SECONDS_BOING_JUMP * MAX_HEIGHT_BOING
			pass
	else:
		spriteEnemy.get_parent().scale =  Vector2.ONE
	boing_state -= delta


func _on_beat_launched(num_beat: int) -> void:
	if(!on_screen):
		return
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
		var note = shoot_partition.get_curr_note()
		$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
		$InstrumentPlayer.play()
		shoot_multiple_projectiles()
		
		

func shoot_multiple_projectiles():
	var rotationshoot=0;
	if hasRotationBullet:
		rotationshoot=rotationBullet
	for i in range(0,nb_projectile_shoot,1):
		var angle = i*(360.0/nb_projectile_shoot) + 90 + rotationshoot
		var rotation_radians = deg_to_rad(angle)
		var direction = Vector2(cos(rotation_radians), sin(rotation_radians))
		
		direction = direction.normalized()
		
		shoot_projectile(direction , direction)
		pass
	
func shoot_projectile(target_direction: Vector2 ,position_offset: Vector2 ):
	
	var shooter_projectile = shooter_projectile_preload.instantiate()
	var sprite_bullet = shooter_projectile.find_child("Sprite2D")
	sprite_bullet.scale= Vector2(Globals.BULLET_SIZE_MULT_ENEMY,Globals.BULLET_SIZE_MULT_ENEMY)
	var collision_shape_bullet =shooter_projectile.find_child("TurretProjectileCollision")
	collision_shape_bullet.scale=  Vector2(Globals.BULLET_SIZE_MULT_ENEMY,Globals.BULLET_SIZE_MULT_ENEMY)
	
	shooter_projectile.set_position(position + position_offset )
	# May be used when ennemies move
	var linear_velocity = Vector2.ZERO 
	shooter_projectile.set_velocity(linear_velocity + target_direction.normalized() * shooter_projectile_speed*Globals.BULLET_TRAVEL_MULT_ENEMY )
	get_parent().add_child(shooter_projectile)


func _on_timer_blink_turrettimeout() -> void:
	if spriteEnemy.visible==false:
		spriteEnemy.show()
	else :
		spriteEnemy.hide()
	nbBlink-=1
	if nbBlink<=0:
		TimerBlinkNode.stop()



	


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false # Replace with function body.
