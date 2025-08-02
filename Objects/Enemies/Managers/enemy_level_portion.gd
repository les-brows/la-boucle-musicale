extends Node2D

class_name EnemyLevelPortion

var shooter_preload = preload("res://Objects/Enemies/Shooter.tscn");

func _init() -> void:
	for index in range(5):
		var curr_shooter: Enemy = shooter_preload.instantiate()
		curr_shooter.position = Vector2(randi_range(500, 4500), randi_range(100, 600))
		add_child(curr_shooter)


func set_player(player: Player):
	for enemy in get_children():
		if enemy is Enemy:
			enemy.set_player(player)
