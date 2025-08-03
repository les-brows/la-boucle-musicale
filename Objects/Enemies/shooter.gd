extends Enemy



var shooter_projectile_preload = preload("res://Objects/Projectiles/ShooterProjectile.tscn");
var shooter_projectile_speed: float = 1000

const NB_SECONDS_BOING_JUMP: float = 0.05
const NB_SECONDS_BOING_RECOVER: float = 0.15
const MAX_HEIGHT_BOING: float = 0.1

var boing_state: float = 0

var shoot_partition: Partition
var movement_pattern: int #EnemyMovementPattern
var on_screen: bool = false
var path_follow: PathFollow2D

@onready var horizontal_path: PathFollow2D = $HorizontalPath/PathFollow2D
@onready var vertical_path: PathFollow2D = $VerticalPath/PathFollow2D
@onready var diamond_path: PathFollow2D = $DiamondPath/PathFollow2D

var health_bar: TextureProgressBar


func _init() -> void:
	super()
	generate_partition(Globals.LOOP_COUNT)


func generate_partition(loop_count: int):
	match loop_count:
		0:
			var list_notes: Array[Note] = [Note.new(0, 0, 3), Note.new(3, 0, -2), Note.new(4, 0, 3)]
			shoot_partition = Partition.new(8, 8, list_notes)
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
	choose_movement_pattern()

func choose_movement_pattern():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_num: int = rng.randi_range(0, EnemyMovementPattern.SIZE - 1)
	match random_num:
		EnemyMovementPattern.HORIZONTAL:
			movement_pattern = EnemyMovementPattern.HORIZONTAL
			spriteEnemy = $HorizontalPath/PathFollow2D/Subgroup/Sprite2D
			health_bar = $HorizontalPath/PathFollow2D/HealthBar
			path_follow = horizontal_path
			
			vertical_path.queue_free()
			diamond_path.queue_free()
		EnemyMovementPattern.VERTICAL:
			movement_pattern = EnemyMovementPattern.VERTICAL
			spriteEnemy = $VerticalPath/PathFollow2D/Subgroup/Sprite2D
			health_bar = $VerticalPath/PathFollow2D/HealthBar
			path_follow = vertical_path
			position.y = 300
			
			horizontal_path.queue_free()
			diamond_path.queue_free()
		EnemyMovementPattern.DIAMOND:
			movement_pattern = EnemyMovementPattern.DIAMOND
			spriteEnemy = $DiamondPath/PathFollow2D/Subgroup/Sprite2D
			health_bar = $DiamondPath/PathFollow2D/HealthBar
			path_follow = diamond_path
			position.y = clamp(position.y, 300, 400)
			
			horizontal_path.queue_free()
			vertical_path.queue_free()
			
	path_follow.progress_ratio = rng.randf_range(0, 1)

func _process(delta: float) -> void:
	if(finito):
		return
	path_follow.progress_ratio += Globals.ENEMY_MOVEMENT_SPEED
	if(path_follow.progress_ratio >= 1):
		path_follow.progress_ratio = 0

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
	if(!on_screen or finito):
		return
	if(num_beat == shoot_partition.get_next_beat(num_beat)):
		boing_state = NB_SECONDS_BOING_RECOVER + NB_SECONDS_BOING_JUMP
		var note = shoot_partition.get_curr_note()
		$InstrumentPlayer.pitch_scale = pow(2, note.pitch/12.0)
		$InstrumentPlayer.play()
		if(player == null):
			shoot_projectile(Vector2(-1, 0))
		else :
			shoot_projectile(player.global_position - global_position)


func shoot_projectile(target_direction: Vector2):
	var shooter_projectile = shooter_projectile_preload.instantiate()
	shooter_projectile.set_position(position + path_follow.position)
	# May be used when ennemies move
	var linear_velocity = Vector2.ZERO 
	shooter_projectile.set_velocity(linear_velocity + target_direction.normalized() * shooter_projectile_speed )
	get_parent().add_child(shooter_projectile)
	

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	on_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	on_screen = false


func take_hit():
	super()
	var health_bar_tween: Tween = create_tween()
	var health_percent: float = hp_enemy as float / hp_max_enemy as float
	health_percent *= 100
	health_bar_tween.tween_property(health_bar, "value", health_percent, Globals.HEALTHBAR_TWEEN_TIMEOUT)
	print(health_percent)
	print(hp_enemy)
	print(hp_max_enemy)
