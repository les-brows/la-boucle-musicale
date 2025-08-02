extends CharacterBody2D

class_name Player

@export var speed = 200.0
@export var size: Vector2 
@export var move_factor : float = 0.2

var targetDir : Vector2 = Vector2(0, 0)
@export var inputManagerNode  :Node 
@export var TimerInvincibilityNode  :Node 
@export var TimerColorNode  :Node 
@export var spritePlayer  :Sprite2D 

var curr_look : float = 0 
var real_velocity : Vector2
var push_force = 80.0
var old_modulate :Color 


var curr_hp: float = Globals.MAX_HP

func _ready():
	old_modulate= spritePlayer.self_modulate
	size = $CollisionShape2D.shape.size
	inputManagerNode.move_update.connect(_on_player_move)
	inputManagerNode.shoot_update.connect(_on_player_shoot)


func _physics_process(delta):
	velocity = targetDir * speed
	if(targetDir.length() > 0.01):
		curr_look = targetDir.angle()

	var collided_entity: KinematicCollision2D = move_and_collide(velocity * delta);
	if(collided_entity != null):
		var collider : Node2D = collided_entity.get_collider()
		real_velocity = collided_entity.get_remainder()
		if (collider is CharacterBody2D):
			collider.move_and_collide(velocity.length() * move_factor * delta * (collider.global_position - global_position).normalized())
		else:
			if collider is RigidBody2D:
				collider.apply_central_impulse(-collided_entity.get_normal() * push_force)
			else:
				collided_entity = move_and_collide(velocity.project(collided_entity.get_normal().orthogonal()) * delta);
				if(collided_entity != null):
					real_velocity = collided_entity.get_remainder()
	else:
		real_velocity = velocity
	
	#$KeySprite.visible =  press_action.get_connections().size() > 0
	
func _on_player_move(move_x :float, move_y : float) -> void:
	targetDir.x = move_x
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()
		
	targetDir.y = move_y
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()


func _on_player_shoot() -> void:
	#TODO
	pass 



func _process(_delta: float):
	if insideEnemy >0 && !invincible  :
		
		take_hit()
			
	
		
var finito = false
var insideEnemy  : int = 0
var invincible : bool = false

func take_hit():
	curr_hp -= 1
	if curr_hp <= 0:
		if not finito:
			finito = true
			print("-----Player Dead---------") 
			spritePlayer.self_modulate = Color.BLACK
			#TODO Game Over
			
	else :
		print("take Hit ") 
		
		invincible=true
		old_modulate=spritePlayer.self_modulate
		TimerInvincibilityNode.set_one_shot (true)
		TimerInvincibilityNode.start(Globals.INVINCIBILITY_TIMER)
		spritePlayer.hide()
		
		TimerColorNode.start(0.10)
		#$/root/GameRoom/EnemyHurtSound.play()
		pass
	

func _on_detection_dmg_area_entered(area: Area2D) -> void:
	var enemy= area.get_parent()
	
	if enemy is Enemy:
		insideEnemy+=1
	if enemy is Projectile   :
		take_hit() 
		if(!invincible):
			print("projectile to kill"+enemy.to_string())
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
	print("end of invisible")
	invincible=false # Replace with function body.


func _on_timerColor_timeout() -> void:
	if spritePlayer.visible==false:
		spritePlayer.show()
	else :
		spritePlayer.hide()
	
	if !invincible && spritePlayer.visible==true:
		TimerColorNode.stop()
