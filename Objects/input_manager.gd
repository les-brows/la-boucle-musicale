extends Node

signal move_update(move_x : Array[float], move_y : Array[float])
signal shoot_update()


static var move_directions_x:Array[float] = [0,0,0]
static var move_directions_y:Array[float] = [0,0,0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_input()
	update_shoot_input()
	

func update_input():
	# Horizontal input
	if Input.is_action_pressed("player1_left"):
		move_directions_x[0] = -Input.get_action_strength("player1_left")
	else:
		if Input.is_action_pressed("player1_right"):
			move_directions_x[0] = Input.get_action_strength("player1_right")
		else:
			move_directions_x[0] = 0
			
	
			
			
	# Vertical input
	if Input.is_action_pressed("player1_up"):
		move_directions_y[0] = -Input.get_action_strength("player1_up")
	else:
		if Input.is_action_pressed("player1_down"):
			move_directions_y[0] = Input.get_action_strength("player1_down")
		else:
			move_directions_y[0] = 0
	

	move_update.emit(move_directions_x, move_directions_y)
	
		
		


func update_shoot_input() -> void:
	

	if Input.is_action_just_pressed("player1_kick"):
		
		shoot_update.emit()
