extends Node2D

class_name EnemyLevelPortion

var shooter_preload = preload("res://Objects/Enemies/Shooter.tscn");
var laser_preload = preload("res://Objects/Enemies/Laser.tscn");

var loop: int = 0

func _init() -> void:
	enemy_generation()

func set_loop(_loop: int):
	loop = _loop

func set_player(player: Player):
	for enemy in get_children():
		if enemy is Enemy:
			enemy.set_player(player)
			
func enemy_generation():
	match loop:
		0:
			#Cut the map in eight, with at least one enemy in each trunk
			for index in range(8):
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / 10 - 60) + (index + 2) * Globals.LEVEL_SIZE / 10, randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), EnemyType.SHOOTER)
				add_enemy(Vector2(randi_range(60, Globals.LEVEL_SIZE / 10 - 60) + (index + 2) * Globals.LEVEL_SIZE / 10, randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60)), EnemyType.LASER)
			pass
		_:
			for index in range(500):
				var curr_shooter: Enemy = shooter_preload.instantiate()
				curr_shooter.position = Vector2(randi_range(500, 4500), randi_range(Globals.BOUNDARY_LOW + 60, Globals.BOUNDARY_UP - 60))
				add_child(curr_shooter)
				print("NOT IMPLEMENTED GET DUNKED ON")


func add_enemy(pos: Vector2, enemy_type: int):
	var curr_enemy: Enemy = null
	match enemy_type:
		EnemyType.SHOOTER:
			curr_enemy = shooter_preload.instantiate()
		EnemyType.LASER:
			curr_enemy = laser_preload.instantiate()
	
	
	curr_enemy.position = pos
	add_child(curr_enemy)
