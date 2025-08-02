extends Node2D

var enemy_level_portion_preload = preload("res://Objects/Enemies/Managers/EnemyLevelPortion.tscn");

var list_enemy_level_portions: Array[EnemyLevelPortion]
var currently_moving_level: bool = false


func _init() -> void:
	var curr_enemy_level_portion: EnemyLevelPortion = enemy_level_portion_preload.instantiate()
	curr_enemy_level_portion.position = Vector2(-Globals.LEVEL_SIZE, 0)
	list_enemy_level_portions.append(curr_enemy_level_portion)
	call_deferred("add_child", curr_enemy_level_portion)
	
	var next_enemy_level_portion: EnemyLevelPortion = enemy_level_portion_preload.instantiate()
	list_enemy_level_portions.append(next_enemy_level_portion)
	call_deferred("add_child", next_enemy_level_portion)
	
	Globals.middle_level_reached.connect(_on_middle_level_reached)
	Globals.end_level_reached.connect(_on_end_level_reached)

func _on_middle_level_reached() -> void:
	currently_moving_level = false
	
	var next_enemy_level_portion: EnemyLevelPortion = enemy_level_portion_preload.instantiate()
	next_enemy_level_portion.position = Vector2(Globals.LEVEL_SIZE, 0)
	list_enemy_level_portions.append(next_enemy_level_portion)
	call_deferred("add_child", next_enemy_level_portion)
	
	# Remove previous level portion
	for enemy_level_portion in list_enemy_level_portions:
		if(enemy_level_portion.position == -Vector2(Globals.LEVEL_SIZE, 0)):
			list_enemy_level_portions.erase(enemy_level_portion)
			enemy_level_portion.queue_free()
			


func _on_end_level_reached() -> void:
	if(currently_moving_level):
		return
	currently_moving_level = true
	
	for enemy_level_portion in list_enemy_level_portions:
		enemy_level_portion.position -= Vector2(Globals.LEVEL_SIZE, 0)
