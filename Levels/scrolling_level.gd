extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player
@onready var level_portions = $LevelPortions
@onready var level_portion_previous = $LevelPortions/LevelPortionPrevious
@onready var level_portion_current = $LevelPortions/LevelPortionCurrent

var currently_moving_level_middle: bool = false
var currently_moving_level_end: bool = false

var LevelPortionScene = preload("res://Levels/LevelPortion.tscn")

@onready var CAMERA_SIZE = get_viewport_rect().size

func move_camera():
	camera.position = camera.position + Vector2(Globals.CAMERA_SPEED, 0)	

func clamp_player_inside_camera():
	player.position.x = clamp(
		player.position.x, 
		camera.position.x - CAMERA_SIZE.x/2 + player.size.x/2, 
		camera.position.x + CAMERA_SIZE.x/2 - player.size.x/2)

func _process(_delta):
	move_camera()
	clamp_player_inside_camera()
	
func _ready():
	$EnemyManager.set_player($Player)
	
	Globals.middle_level_reached.connect(_on_middle_level_reached)
	Globals.end_level_reached.connect(_on_end_level_reached)
	
	level_portion_previous.position = -Vector2(Globals.LEVEL_SIZE, 0)
	
	

func _on_middle_level_reached() -> void:
	currently_moving_level_end = false
	
	if(currently_moving_level_middle):
		return
		
	currently_moving_level_middle = true
	
	# Add level a level to next position
	var level_portion_scene_instance = LevelPortionScene.instantiate()
	level_portions.call_deferred("add_child", level_portion_scene_instance)
	level_portion_scene_instance.position = Vector2(Globals.LEVEL_SIZE, 0)
	
	# Remove previous level portion
	for level_portion in level_portions.get_children():
		if level_portion.position == -Vector2(Globals.LEVEL_SIZE, 0):
			level_portion.queue_free()
			
			
	print("Player hit the middle of the level !")
	
func _on_end_level_reached() -> void:
	currently_moving_level_middle = false
	
	if(currently_moving_level_end):
		return
		
	currently_moving_level_end = true
	
	# Shift all level portions to the left
	for level_portion in level_portions.get_children():
		level_portion.position = level_portion.position - Vector2(Globals.LEVEL_SIZE, 0)
	
	# Shift character to the left
	player.position = player.position - Vector2(Globals.LEVEL_SIZE, 0)
		
	# Shift camera to the left
	camera.position = camera.position - Vector2(Globals.LEVEL_SIZE, 0)
		
	print("Player hit the end of the level !")
