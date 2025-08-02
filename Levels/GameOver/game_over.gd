extends Control


func _ready() -> void:
	Globals.player_death.connect(_on_player_death)
	
func _on_player_death():
	print("displaying error")
	var main_menu = load("res://Levels/MainMenu/MainMenu.tscn")
	visible = true
	await get_tree().create_timer(3.0).timeout
	
	await SceneTransition.close_circle()
	visible = false
	get_node("/root/MainScene").queue_free()
	get_tree().get_root().add_child(main_menu.instantiate())
	await SceneTransition.open_circle()
