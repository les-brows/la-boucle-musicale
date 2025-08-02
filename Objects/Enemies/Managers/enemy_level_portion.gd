extends Node2D

class_name EnemyLevelPortion

var shooter_preload = preload("res://Objects/Enemies/Shooter.tscn");

func _init() -> void:
	for index in range(5):
		var curr_shooter: Enemy = shooter_preload.instantiate()
		curr_shooter.position = Vector2(randi_range(500, 4500), randi_range(100, 600))
		call_deferred("add_child", curr_shooter)
