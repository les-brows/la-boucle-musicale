extends CanvasLayer
			
var half_heart_texture = preload('res://Assets/half_heart.png')
var heart_texture = preload('res://Assets/heart.png')

@onready var label = $Label
@onready var heart_1 = $HBoxContainer/Heart1
@onready var heart_2 = $HBoxContainer/Heart2
@onready var heart_3 = $HBoxContainer/Heart3
@onready var heart_4 = $HBoxContainer/Heart4
@onready var heart_5 = $HBoxContainer/Heart5

func _ready():
	Globals.end_level_reached.connect(_on_end_level_reached)
	Globals.player_damage.connect(_on_player_damage)
	Globals.hp_changed.connect(_on_hp_changed)
	
func _on_end_level_reached():
	label.text = "Number of Loops : " + str(Globals.LOOP_COUNT)

func _on_hp_changed():
	update_hp(Globals.CURRENT_HP_PLAYER)
	
func _on_player_damage(player_hp: int):
	update_hp(player_hp)
	
func update_hp(player_hp: int):
	match player_hp:
		10:
			heart_1.texture = heart_texture
			heart_2.texture = heart_texture
			heart_3.texture = heart_texture
			heart_4.texture = heart_texture
			heart_5.texture = heart_texture
		9:
			heart_1.texture = half_heart_texture
		8:
			heart_1.texture = null
		7:
			heart_2.texture = half_heart_texture
		6:
			heart_2.texture = null
		5:
			heart_3.texture = half_heart_texture
		4:
			heart_3.texture = null
		3:
			heart_4.texture = half_heart_texture
		2:
			heart_4.texture = null
		1:
			heart_5.texture = half_heart_texture
		0:
			heart_5.texture = null
		
	
