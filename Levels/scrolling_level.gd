extends Node2D

@onready var camera = $Camera2D

func move_camera():
	camera.position = camera.position + Vector2(Globals.CAMERA_SPEED, 0)	

func _process(delta):
	move_camera()


func _on_end_line_body_entered(body: Node2D) -> void:
	print("Player hit the middle of the level !")


func _on_middle_line_body_entered(body: Node2D) -> void:
	print("Player hit the end of the level !")
