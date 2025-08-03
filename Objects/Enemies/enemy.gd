class_name Enemy
extends Node2D

var player: Player = null
var hp_enemy: int = Globals.ENEMY_MAXHP
var hp_max_enemy: int = Globals.ENEMY_MAXHP

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
	if(finito):
		return
	var playerProjectile= area.get_parent()
	if playerProjectile is Projectile   :
		take_hit() 
		playerProjectile.queue_free() # Replace with function body.

var finito=false

func take_hit():
	Globals.enemy_damage.emit()
	hp_enemy = max(0, hp_enemy - 1)
	
	spriteEnemy.hide()
	nbBlink=3
	TimerBlinkNode.start(0.05)
	
	if hp_enemy <= 0:
		finito = true
		print("-----Enemey Dead---------")
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
func _on_timer_blink_timeout() -> void:
	
	if spriteEnemy.visible==false:
		spriteEnemy.show()
	else :
		spriteEnemy.hide()
	nbBlink-=1
	if nbBlink<=0:
		TimerBlinkNode.stop()

func generate_partition(_loop_count: int, _curr_variant: int):
	pass
