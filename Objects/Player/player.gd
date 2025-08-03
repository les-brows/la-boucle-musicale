extends CharacterBody2D

class_name Player

@export var size: Vector2 
@export var move_factor : float = 0.5

var targetDir : Vector2 = Vector2(0, 0)
@export var inputManagerNode  :Node 
@export var TimerInvincibilityNode  :Node 
@export var TimerColorNode  :Node 
@export var spritePlayer  :Sprite2D 
@export var ShootManagerNode  :Node

 
#Slow
var mult_slow=1
var mult_slow_min=0.25
# Dash
var dashCooldown :bool= false 
@export var DashCooldownTimer :Node

var dashSpeed=Globals.SPEED_DASH_MAX
var TimeEndDash=0
var dashDir : Vector2= Vector2(0, 0)

var real_velocity : Vector2
var push_force = 80.0
var old_modulate :Color 

var try_play_dash_sound: bool = false


func _ready():
	Globals.CURRENT_HP_PLAYER = Globals.MAX_HP
	Globals.beat_launched.connect(_on_beat_launched)
	old_modulate= spritePlayer.self_modulate
	size = $CollisionShape2D.shape.size
	inputManagerNode.move_update.connect(_on_player_move)
	inputManagerNode.slow_end_update.connect(_on_player_end_slow)
	inputManagerNode.slow_begin_update.connect(_on_player_begin_slow)
	inputManagerNode.dash_update.connect(_on_activate_dash)
	inputManagerNode.shoot_update.connect(ShootManagerNode._on_player_shoot)
	inputManagerNode.shoot_direction_update.connect(ShootManagerNode._on_player_direction_shoot)
	ShootManagerNode.positionPlayer=position
	
func _physics_process(delta):
	if(TimeEndDash>0):
		
		velocity = dashDir * dashSpeed
		dashSpeed-= delta*(Globals.DASH_TIME-TimeEndDash)
		TimeEndDash-=delta
		
	else:
		velocity = targetDir * Globals.NORMAL_SPEED_PLAYER*Globals.MOVE_SPEED_MULT_PLAYER*mult_slow
		
	if velocity.length() > 0:
		move_and_slide()
	#$KeySprite.visible =  press_action.get_connections().size() > 0
	
func _on_player_move(move_x :float, move_y : float) -> void:
	
	var tween = get_tree().create_tween()
	if(move_x == 0 && move_y == 0):
		tween.tween_property(spritePlayer, "scale", Vector2(0.20, 0.20), 0.2)
	if(move_x != 0 && move_y == 0):
		tween.tween_property(spritePlayer, "scale", Vector2(0.3, 0.12), 0.2)
	if(move_x == 0 && move_y != 0):
		tween.tween_property(spritePlayer, "scale", Vector2(0.12, 0.3), 0.2)
	if(move_x != 0 && move_y != 0):
		tween.tween_property(spritePlayer, "scale", Vector2(0.15, 0.15), 0.2)
	
	targetDir.x = move_x
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()
		
	targetDir.y = move_y
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()


func _on_player_end_slow():
	mult_slow =1.0

func _on_player_begin_slow():

	mult_slow =mult_slow_min

func _process(_delta: float):
	if insideEnemy >0 && !invincible  :
		
		take_hit()
			
	
		
var finito = false
var insideEnemy  : int = 0
var invincible : bool = false
var alphaColor =0

func take_hit():
	if(finito):
		return
	var alea= randf_range(0, 99)
	if(alea>=Globals.LUCK_DODGE):
		Globals.CURRENT_HP_PLAYER -= 1
		Globals.player_damage.emit(Globals.CURRENT_HP_PLAYER)
		
		if Globals.CURRENT_HP_PLAYER <= 0:
			if not finito:
				finito = true
				print("-----Player Dead---------")
				spritePlayer.texture = load('res://Assets/main_char_damage.png')
				ShootManagerNode.isDead=true
				Globals.player_death.emit()
		else :
			
			
			invincible=true
			old_modulate=spritePlayer.self_modulate
			
			TimerInvincibilityNode.set_one_shot (true)
			TimerInvincibilityNode.start(Globals.INVINCIBILITY_TIMER)
			spritePlayer.hide()
			alphaColor =0.5
			spritePlayer.self_modulate= Color (0.5,1,0,alphaColor)
			TimerColorNode.start(0.05)
			#$/root/GameRoom/EnemyHurtSound.play()
			pass
	else :
		print("Dodgee")

func _on_detection_dmg_area_entered(area: Area2D) -> void:
	var enemy= area.get_parent()
	
	if enemy is Enemy:
		insideEnemy+=1
	if enemy is Projectile:
		if(!invincible):
			take_hit() 
		enemy.queue_free()

func _on_detection_dmg_area_exited(area: Area2D) -> void:
	var eneny= area.get_parent()
	if eneny is Enemy:
		if(insideEnemy >0):
			insideEnemy-=1
		else :
			print("Error exited more exited more node than entered ")
	 # Replace with f


func _on_timerInvincibility_timeout() -> void:
	invincible=false # Replace with function body.


func _on_timerColor_timeout() -> void:
	
	if spritePlayer.visible==false:
		spritePlayer.show()
	else :
		spritePlayer.hide()
	
	if !invincible :
		spritePlayer.self_modulate=Color (1,1,1,1)
		if spritePlayer.visible==true:
			TimerColorNode.stop()
	else :  	
		alphaColor+=0.1
		spritePlayer.self_modulate= Color (0.5,alphaColor,1,alphaColor)
		

func _on_activate_dash() -> void:
	if !dashCooldown  :
		TimeEndDash=Globals.DASH_TIME
		dashSpeed=Globals.SPEED_DASH_MAX
		dashDir = targetDir.normalized()
		try_play_dash_sound = true
		invincible=true 
		TimerInvincibilityNode.set_one_shot (true)
		TimerInvincibilityNode.start(Globals.DASH_TIME)
		dashCooldown=true
		DashCooldownTimer.set_one_shot(true)
		DashCooldownTimer.start(Globals.COOLDOWN_DASH)

func _on_beat_launched(_beat: int):
	if(try_play_dash_sound):
		try_play_dash_sound = false
		$PlayerDashSfx.play()

func generate_partition(loop_count: int):
	$ShootPlayerManager.generate_partition(loop_count)


func DashCooldownTimer_timeOut()->void:
	dashCooldown=false
