class_name Enemy
extends Node2D

var player: Player = null
var hp_enemy:int= Globals.ENEMY_MAXHP

@export var spriteEnemy :Node 
@export var TimerBlinkNode : Node 
var nbBlink :int  =0

func _init() -> void:
	Globals.beat_launched.connect(_on_beat_launched)


func _on_beat_launched(_num_beat: int) -> void:
	pass

func set_player(_player: Player):
	player = _player

func _on_shooter_collision_area_2d_area_entered(area: Area2D) -> void:
	var playerProjectile= area.get_parent()
	if playerProjectile is Projectile   :
		take_hit() 
		playerProjectile.queue_free() # Replace with function body.

var finito=false

func take_hit():
	Globals.enemy_damage.emit()
	hp_enemy -= 1
	if hp_enemy <= 0:
		if not finito:
			finito = true
			print("-----Enemey Dead---------")
			queue_free()
	else :
		spriteEnemy.hide()
		nbBlink=3
		TimerBlinkNode.start(0.05)
		#$/root/GameRoom/EnemyHurtSound.play()
		pass
		
func _on_timer_blink_timeout() -> void:
	if spriteEnemy.visible==false:
		spriteEnemy.show()
	else :
		spriteEnemy.hide()
	nbBlink-=1
	if nbBlink<=0:
		TimerBlinkNode.stop()
		
