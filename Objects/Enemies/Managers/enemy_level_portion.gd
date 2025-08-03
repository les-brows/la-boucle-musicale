extends Node2D

class_name EnemyLevelPortion

var shooter_preload = preload("res://Objects/Enemies/Shooter.tscn");
var laser_preload = preload("res://Objects/Enemies/Laser.tscn");

var loop: int = 0


func set_loop(_loop: int):
	loop = _loop
 
func set_player(player: Player):
	for enemy in get_children():
		if enemy is Enemy:
			enemy.set_player(player)
 
func generate_partition(partition: int):
	for enemy in get_children():
		if enemy is Enemy:
			enemy.generate_partition(partition) 

func enemy_generation(player: Player, loop: int):
	match loop:
		0:
			#For the first map, let at least 400 px free
			for index in range(4):
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + ((index + 1) * 2 + 1)* Globals.LEVEL_SIZE / 10.0, 
								  Globals.BOUNDARY_LOW + 60), 
								  EnemyType.SHOOTER, EnemyMovementPattern.VERTICAL, 0, player, loop)
		1:
			#For the first map, let at least 400 px free
			for index in range(5):
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + (index * 2 + 1)* Globals.LEVEL_SIZE / 10.0, 
								  Globals.BOUNDARY_LOW + 60), 
								  EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
				#add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + ((index + 1) * 2) * Globals.LEVEL_SIZE / 10.0, 
								 #Globals.BOUNDARY_LOW + 60), EnemyType.LASER, player, loop)
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + (index * 2) * Globals.LEVEL_SIZE / 10.0, 
								  Globals.BOUNDARY_UP - 60), EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
		2:
			for index in range(10):
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + index * Globals.LEVEL_SIZE / 10.0, 
								 (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP + 60)  / 2), EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, index % 2, player, loop)
		3:
			#Cut the map in ten, with at least one enemy in each trunk
			for index in range(10):
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / 10.0 - 60) + index * Globals.LEVEL_SIZE / 10.0,
								  randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), 
						  EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / 10.0 - 60) + index * Globals.LEVEL_SIZE / 10.0, 
								  randi_range(Globals.BOUNDARY_LOW + 200, Globals.BOUNDARY_UP - 200)), 
						  EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
			pass
		_:
			for index in range(500):
				var curr_shooter: Enemy = shooter_preload.instantiate()
				curr_shooter.position = Vector2(randi_range(500, 4500), randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60))
				add_child(curr_shooter)
				print("NOT IMPLEMENTED GET DUNKED ON")


func add_enemy(pos: Vector2, enemy_type: int, movement_type: int, pattern_variant: int, player: Player, loop: int):
	var curr_enemy: Enemy = null
	match enemy_type:
		EnemyType.SHOOTER:
			curr_enemy = shooter_preload.instantiate()
			curr_enemy.choose_movement_pattern(movement_type)
		EnemyType.LASER:
			curr_enemy = laser_preload.instantiate()
	
	curr_enemy.position = pos
	curr_enemy.set_player(player)
	curr_enemy.generate_partition(loop, pattern_variant)
	add_child(curr_enemy)
