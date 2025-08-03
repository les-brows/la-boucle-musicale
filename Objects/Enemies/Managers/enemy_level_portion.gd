extends Node2D

class_name EnemyLevelPortion

var shooter_preload = preload("res://Objects/Enemies/Shooter.tscn");
var laser_preload = preload("res://Objects/Enemies/Laser.tscn");
var turret_preload = preload("res://Objects/Enemies/Turret.tscn");

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
			add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + 4 * Globals.LEVEL_SIZE / 10.0, 
								  (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP + 60)  / 2.0), 
								  EnemyType.TURRET, EnemyMovementPattern.VERTICAL, 0, player, loop)
		1:
			#For the first map, let at least 400 px free
			for index in range(5):
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + (index * 2 + 1)* Globals.LEVEL_SIZE / 10.0, 
								  Globals.BOUNDARY_LOW + 60), 
								  EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
				#add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + ((index + 1) * 2) * Globals.LEVEL_SIZE / 10.0, 
								 #Globals.BOUNDARY_LOW + 60), EnemyType.LASER, player, loop)
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + (index * 2) * Globals.LEVEL_SIZE / 10.0, 
								  Globals.BOUNDARY_UP - 60), EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 1, player, loop)
		2:
			for index in range(10):
				add_enemy(Vector2(Globals.LEVEL_SIZE / 20.0 + index * Globals.LEVEL_SIZE / 10.0, 
								 (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP + 60)  / 2.0), EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, index % 2, player, loop)
		3:
			var subdiv: float = 5.0
			for index in range(subdiv):
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / (subdiv + 1) - 60) + index * Globals.LEVEL_SIZE / (subdiv + 1),
								  randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), 
						  EnemyType.TURRET, EnemyMovementPattern.DIAMOND, 0, player, loop)

			subdiv = 4.0
			for index in range(subdiv):
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / (subdiv + 1) - 60) + index * Globals.LEVEL_SIZE / (subdiv + 1), 
								  randi_range(Globals.BOUNDARY_LOW + 200, Globals.BOUNDARY_UP - 200)), 
						  EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
		4:
			#Cut the map in ten, with at least one enemy in each trunk
			var subdiv: float = 4.0
			for index in range(subdiv):
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / subdiv - 60) + index * Globals.LEVEL_SIZE / subdiv,
								  randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), 
						  EnemyType.SHOOTER, EnemyMovementPattern.DIAMOND, 0, player, loop)
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / subdiv - 60) + index * Globals.LEVEL_SIZE / subdiv, 
								  randi_range(Globals.BOUNDARY_LOW + 200, Globals.BOUNDARY_UP - 200)), 
						  EnemyType.TURRET, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
			pass
		_:
			var infinite_count: int = loop % Globals.NB_LEVEL_INFINITE
			match infinite_count:
				0:
					var subdiv: float = 10.0
					for index in range(subdiv):
						add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / ((subdiv + 1 ) + 1) - 60) + (index + 1) * Globals.LEVEL_SIZE / ((subdiv + 1) + 1), 
										  randi_range((Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP ) / 2 - 100, (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP ) / 2 + 100)), 
								  EnemyType.TURRET, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
					subdiv = 5.0
					for index in range(subdiv):
						add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / ((subdiv + 1 ) + 1) - 60) + (index + 1) * Globals.LEVEL_SIZE / ((subdiv + 1) + 1), 
										  randi_range((Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP ) / 2 - 100, (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP ) / 2 + 100)), 
								  EnemyType.SHOOTER, EnemyMovementPattern.RANDOM, 0, player, loop)
				1:
					var subdiv: float = 10.0
					for index in range(subdiv):
						add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / (subdiv + 1) - 60) + index * Globals.LEVEL_SIZE / (subdiv + 1), 
										  randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_LOW + 60 + 100)), 
								  EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
						add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / (subdiv + 1) - 60) + index * Globals.LEVEL_SIZE / (subdiv + 1), 
										  randi_range(Globals.BOUNDARY_UP - 60, Globals.BOUNDARY_UP - 60 - 100)), 
								  EnemyType.LASER, EnemyMovementPattern.UNMOVABLE, 1, player, loop)
					
					subdiv = 4.0
					for index in range(subdiv):
						add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / ((subdiv + 1 ) + 1) - 60) + (index + 1) * Globals.LEVEL_SIZE / ((subdiv + 1) + 1), 
										  (Globals.BOUNDARY_LOW + Globals.BOUNDARY_UP + 60) / 2), 
								  EnemyType.TURRET, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
					
				_:
					for index in range(500):
						add_enemy(Vector2(randi_range(500, 4500), randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), 
									EnemyType.SHOOTER, EnemyMovementPattern.UNMOVABLE, 0, player, loop)
						print("NOT IMPLEMENTED GET DUNKED ON")


func add_enemy(pos: Vector2, enemy_type: int, movement_type: int, pattern_variant: int, player: Player, loop: int):
	var curr_enemy: Enemy = null
	match enemy_type:
		EnemyType.SHOOTER:
			curr_enemy = shooter_preload.instantiate()
			curr_enemy.choose_movement_pattern(movement_type)
		EnemyType.LASER:
			curr_enemy = laser_preload.instantiate()
		EnemyType.TURRET:
			curr_enemy = turret_preload.instantiate()
	
	curr_enemy.position = pos
	curr_enemy.set_player(player)
	curr_enemy.generate_partition(loop, pattern_variant)
	add_child(curr_enemy)
