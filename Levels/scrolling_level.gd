extends Node2D

@onready var camera = $Camera2D
@onready var player = $Player
@onready var CAMERA_SIZE = get_viewport_rect().size

func move_camera():
	camera.position = camera.position + Vector2(Globals.CAMERA_SPEED, 0)	

func clamp_player_inside_camera():
	player.position.x = clamp(
		player.position.x, 
		camera.position.x - CAMERA_SIZE.x/2 + player.size.x/2, 
		camera.position.x + CAMERA_SIZE.x/2 - player.size.x/2)

func _process(delta):
	move_camera()
	clamp_player_inside_camera()


func _on_end_line_body_entered(body: Node2D) -> void:
	print("Player hit the end of the level !")


func _on_middle_line_body_entered(body: Node2D) -> void:
	print("Player hit the middle of the level !")
