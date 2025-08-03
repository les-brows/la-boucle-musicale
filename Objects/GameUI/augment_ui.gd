extends CanvasLayer

var currently_selected_augment: int = 2
var is_in_augment_menu: bool = false
var can_pass_end_level: bool = false

@onready var augment_1_texture = $Augments/VBoxContainer/HBoxContainer/Augment_1
@onready var augment_2_texture = $Augments/VBoxContainer/HBoxContainer/Augment_2
@onready var augment_3_texture = $Augments/VBoxContainer/HBoxContainer/Augment_3

@onready var augment_1_label = $Augments/VBoxContainer/HBoxContainer/Augment_1/MarginContainer/Label
@onready var augment_2_label = $Augments/VBoxContainer/HBoxContainer/Augment_2/MarginContainer/Label
@onready var augment_3_label = $Augments/VBoxContainer/HBoxContainer/Augment_3/MarginContainer/Label

var shader_material = ShaderMaterial.new()

var augment_1: int = -1
var augment_2: int = -1
var augment_3: int = -1

var ENEMY_BULLET_SIZE_TEXTURE = preload("res://Assets/augment_card_enemy_bullet_size.png")
var PLAYER_BULLET_SIZE_TEXTURE = preload("res://Assets/augment_card_player_bullet_size.png")
var ENEMY_BULLET_SPEED_TEXTURE = preload("res://Assets/augment_card_enemy_bullet_speed.png")
var PLAYER_BULLET_SPEED_TEXTURE = preload("res://Assets/augment_card_player_bullet_speed.png")
var ENEMY_MOVEMENT_SPEED_TEXTURE = preload("res://Assets/augment_card_enemy_speed.png")
var PLAYER_MOVEMENT_SPEED_TEXTURE = preload("res://Assets/augment_card_player_speed.png")
var PLAYER_HEAL_TEXTURE = preload("res://Assets/augment_card_heart.png")
var PLAYER_MELODY_TEXTURE = preload("res://Assets/augment_card_melody.png")
var PLAYER_STRENGTH_TEXTURE = preload("res://Assets/augment_card_player_damage.png")
var PLAYER_DODGE_TEXTURE = preload("res://Assets/augment_card_player_dodge.png")
var PLAYER_BULLET_SPREAD_TEXTURE_1 = preload("res://Assets/augment_card_player_spread_2.png")
var PLAYER_BULLET_SPREAD_TEXTURE_2 = preload("res://Assets/augment_card_player_spread_3.png")

enum Augment {
	ENEMY_BULLET_SIZE,
	PLAYER_BULLET_SIZE,
	ENEMY_BULLET_SPEED,
	PLAYER_BULLET_SPEED,
	ENEMY_MOVEMENT_SPEED,
	PLAYER_MOVEMENT_SPEED,
	PLAYER_HEAL,
	PLAYER_MELODY,
	PLAYER_STRENGTH,
	PLAYER_DODGE,
	PLAYER_BULLET_SPREAD,
	NUM_OF_AUGMENT
}
	

func _ready():
	Globals.end_level_reached.connect(_on_end_level_reached)
	Globals.middle_level_reached.connect(_on_middle_level_reached)
	
	var shader = load("res://Objects/GameUI/AugmentUI.gdshader")
	shader_material.shader = shader
	
func _on_middle_level_reached() -> void:
	can_pass_end_level = true
	
func _on_end_level_reached() -> void:
	if not can_pass_end_level:
		return
		
	can_pass_end_level = false
	generate_augments()
	update_augment_display(currently_selected_augment)
	visible = true
	is_in_augment_menu = true
	
func _process(_delta: float) -> void:
	if not is_in_augment_menu:
		return
		
	var new_currently_selected_augment = currently_selected_augment
		
	if Input.is_action_just_pressed("player1_left"):
		new_currently_selected_augment = max(1, currently_selected_augment - 1)
	if Input.is_action_just_pressed("player1_right"):
		new_currently_selected_augment = min(currently_selected_augment + 1, 3)
	if Input.is_action_just_pressed("ui_accept"):
		var augement_selected = -1
		if currently_selected_augment == 1:
			augement_selected = augment_1
		if currently_selected_augment == 2:
			augement_selected = augment_2
		if currently_selected_augment == 3:
			augement_selected = augment_3
			
		select_augment(augement_selected)
		visible = false
		is_in_augment_menu = false
		Globals.augment_selected.emit()
		return
		
	if new_currently_selected_augment != currently_selected_augment:
		print(new_currently_selected_augment)
		currently_selected_augment = new_currently_selected_augment
		update_augment_display(currently_selected_augment)
		
		
func select_augment(augment_selected) -> void:
	print("augmenting player")
	if augment_selected == Augment.ENEMY_BULLET_SIZE:
		print("augmenting enemy bullet size")
		Globals.BULLET_SIZE_MULT_ENEMY *= 0.8
	if augment_selected == Augment.PLAYER_BULLET_SIZE:
		print("augmenting player bullet size")
		Globals.BULLET_SIZE_MULT_PLAYER += 0.3
	if augment_selected == Augment.ENEMY_BULLET_SPEED:
		print("augmenting enemy bullet speed")
		Globals.BULLET_TRAVEL_MULT_ENEMY *= 0.8
	if augment_selected == Augment.PLAYER_BULLET_SPEED:
		print("augmenting player bullet speed")
		Globals.BULLET_TRAVEL_MULT_PLAYER += 0.3
	if augment_selected == Augment.ENEMY_MOVEMENT_SPEED:
		print("augmenting enemy speed")
		Globals.MOVE_SPEED_MULT_ENEMY *= 0.8
	if augment_selected == Augment.PLAYER_MOVEMENT_SPEED:
		print("augmenting player speed")
		Globals.MOVE_SPEED_MULT_PLAYER += 0.3
	if augment_selected == Augment.PLAYER_HEAL:
		print("healing player")
		Globals.CURRENT_HP_PLAYER = Globals.MAX_HP
		Globals.hp_changed.emit()
	if augment_selected == Augment.PLAYER_MELODY:
		print("augmenting melody")
		Globals.MELODY_LEVEL += 1
	if augment_selected == Augment.PLAYER_STRENGTH:
		print("augmenting strength")
		Globals.DMG_BULLET += 1
	if augment_selected == Augment.PLAYER_DODGE:
		print("augmenting dodge")
		Globals.LUCK_DODGE += 10
	if augment_selected == Augment.PLAYER_BULLET_SPREAD:
		print("augmenting spread")
		Globals.NB_BULLET_PLAYER += 1
	
func generate_augments() -> void:
	var valid_augments: bool = false
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	while(not valid_augments):
		augment_1 = rng.randi_range(0, Augment.NUM_OF_AUGMENT - 1)
		augment_2 = rng.randi_range(0, Augment.NUM_OF_AUGMENT - 1)
		augment_3 = rng.randi_range(0, Augment.NUM_OF_AUGMENT - 1)
		valid_augments = are_augments_valid(augment_1, augment_2, augment_3)
		
	set_augment_texture(augment_1_texture, augment_1_label, augment_1)
	set_augment_texture(augment_2_texture, augment_2_label, augment_2)
	set_augment_texture(augment_3_texture, augment_3_label, augment_3)
	
func set_augment_texture(augment_texture, augment_label, augment) -> void:
	if augment == Augment.ENEMY_BULLET_SIZE:
		augment_texture.texture = ENEMY_BULLET_SIZE_TEXTURE
		augment_label.text = "Reduce enemy\nbullet size\n" + str(int((Globals.BULLET_SIZE_MULT_ENEMY) * 100)) + "% -> " + str(int((Globals.BULLET_SIZE_MULT_ENEMY * 0.8) * 100)) + "%"
	if augment == Augment.PLAYER_BULLET_SIZE:
		augment_texture.texture = PLAYER_BULLET_SIZE_TEXTURE
		augment_label.text = "Increase player\nbullet size\n" + str(int((Globals.BULLET_SIZE_MULT_PLAYER) * 100)) + "% -> " + str(int((Globals.BULLET_SIZE_MULT_PLAYER + 0.3) * 100)) + "%"
	if augment == Augment.ENEMY_BULLET_SPEED:
		augment_texture.texture = ENEMY_BULLET_SPEED_TEXTURE
		augment_label.text = "Reduce enemy\nbullet speed\n" + str(int((Globals.BULLET_TRAVEL_MULT_ENEMY) * 100)) + "% -> " + str(int((Globals.BULLET_TRAVEL_MULT_ENEMY * 0.8) * 100)) + "%"
	if augment == Augment.PLAYER_BULLET_SPEED:
		augment_texture.texture = PLAYER_BULLET_SPEED_TEXTURE
		augment_label.text = "Increase player\nbullet speed\n" + str(int((Globals.BULLET_TRAVEL_MULT_PLAYER) * 100)) + "% -> " + str(int((Globals.BULLET_TRAVEL_MULT_PLAYER + 0.3) * 100)) + "%"
	if augment == Augment.ENEMY_MOVEMENT_SPEED:
		augment_texture.texture = ENEMY_MOVEMENT_SPEED_TEXTURE
		augment_label.text = "Increase enemy\nmovement speed\n" + str(int((Globals.MOVE_SPEED_MULT_ENEMY) * 100)) + "% -> " + str(int((Globals.MOVE_SPEED_MULT_ENEMY * 0.8) * 100)) + "%"
	if augment == Augment.PLAYER_MOVEMENT_SPEED:
		augment_texture.texture = PLAYER_MOVEMENT_SPEED_TEXTURE
		augment_label.text = "Increase player\nmovement speed\n" + str(int((Globals.MOVE_SPEED_MULT_PLAYER) * 100)) + "% -> " + str(int((Globals.MOVE_SPEED_MULT_PLAYER + 0.3) * 100)) + "%"
	if augment == Augment.PLAYER_HEAL:
		augment_texture.texture = PLAYER_HEAL_TEXTURE
		augment_label.text = "Fully heal"
	if augment == Augment.PLAYER_MELODY:
		augment_texture.texture = PLAYER_MELODY_TEXTURE
		augment_label.text = "Upgrade melody"
	if augment == Augment.PLAYER_STRENGTH:
		augment_texture.texture = PLAYER_STRENGTH_TEXTURE
		augment_label.text = "Increase player\nstrength\n" + str(int((Globals.DMG_BULLET) * 100)) + "% -> " + str(int((Globals.DMG_BULLET + 0.1) * 100)) + "%"
	if augment == Augment.PLAYER_DODGE:
		augment_texture.texture = PLAYER_DODGE_TEXTURE
		augment_label.text = "Increase player\nblock chance\n" + str(int((Globals.LUCK_DODGE) * 100)) + "% -> " + str(int((Globals.LUCK_DODGE + 0.1) * 100)) + "%"
	if augment == Augment.PLAYER_BULLET_SPREAD:
		augment_label.text = "Increase player\nbullets per\nshot"
		if Globals.NB_BULLET_PLAYER == 1:
			augment_texture.texture = PLAYER_BULLET_SPREAD_TEXTURE_1
		else:
			augment_texture.texture = PLAYER_BULLET_SPREAD_TEXTURE_2
	
		
func are_augments_valid(augment_1_generated: int, augment_2_generated: int, augment_3_generated: int) -> bool:
	# Are there multiple times the same augment
	if(augment_1_generated == augment_2_generated or augment_1_generated == augment_3 or augment_2_generated == augment_3_generated):
		return false
		
	# If dodge is already at its max level
	if(Globals.LUCK_DODGE >= Globals.DODGE_MAX_PERCENT && 
		(augment_1_generated == Augment.PLAYER_DODGE or augment_2_generated == Augment.PLAYER_DODGE or augment_3_generated == Augment.PLAYER_DODGE)):
		return false
		
	# If bullet spread is already at its max level
	if(Globals.NB_BULLET_PLAYER == Globals.BULLET_SPREAD_MAX_LEVEL && 
		(augment_1_generated == Augment.PLAYER_BULLET_SPREAD or augment_2_generated == Augment.PLAYER_BULLET_SPREAD or augment_3_generated == Augment.PLAYER_BULLET_SPREAD)):
		return false
		
	# If melody is already at its max level
	if(Globals.MELODY_LEVEL == Globals.MELODY_MAX_LEVEL && 
		(augment_1_generated == Augment.PLAYER_MELODY or augment_2_generated == Augment.PLAYER_MELODY or augment_3_generated == Augment.PLAYER_MELODY)):
		return false
		
	# If heal when at full HP
	if(Globals.CURRENT_HP_PLAYER == Globals.MAX_HP && 
		(augment_1_generated == Augment.PLAYER_HEAL or augment_2_generated == Augment.PLAYER_HEAL or augment_3_generated == Augment.PLAYER_HEAL)):
		return false
		
	return true

func update_augment_display(selected_augment: int) -> void:
	if selected_augment == 1:
		augment_1_texture.material = shader_material
		augment_2_texture.material = null
		augment_3_texture.material = null
		
	if selected_augment == 2:
		augment_1_texture.material = null
		augment_2_texture.material = shader_material
		augment_3_texture.material = null
		
	if selected_augment == 3:
		augment_1_texture.material = null
		augment_2_texture.material = null
		augment_3_texture.material = shader_material
