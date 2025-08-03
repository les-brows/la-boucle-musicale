extends MarginContainer

var menu_scene

func _ready() -> void:
	menu_scene = load("res://Levels/MainMenu/MainMenu.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player1_cancel"):
		get_parent().add_child(menu_scene.instantiate())
		queue_free()
		
