extends CharacterBody2D

class_name Player


signal press_action(playerIndex: int, player: Player)

@onready var playerAnimation = $AnimationPlayer

@export var move_factor : float = 0.2
@export var speed : int = 500

var inputManager :Node 

var playerIndex : int = 0
var targetDir : Vector2 = Vector2(0, 0)
var real_velocity : Vector2
var curr_look : float = 0 

var kick_distance : float = 50
var kick_speed : float = 50
var can_kick : bool = true

var propDetected: Node2D 
var can_ping : bool = true

var push_force = 80.0
var launch_force = 1500.0




var nb_prop_connected: int = 0
var prop_drop_distance: float = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$KeyAnimationPlayer.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
	$KeySprite.visible =  press_action.get_connections().size() > 0


func _on_player_move(move_x : Array[float], move_y : Array[float]) -> void:
	targetDir.x = move_x[playerIndex]
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()
		
		
	targetDir.y = move_y[playerIndex]
	if targetDir.length() > 1:
		targetDir = targetDir.normalized()
		
	if targetDir.y < 0:
		playerAnimation.play("Up")
		
	if targetDir.y > 0:
		playerAnimation.play("Down")
		
	if targetDir.x < 0 && targetDir.y == 0:
		playerAnimation.play("Left")
		
	if targetDir.x > 0 && targetDir.y == 0:
		playerAnimation.play("Right")
	
	if targetDir.x == 0 && targetDir.y == 0:
		playerAnimation.stop()



func _on_player_shoot() -> void:
	#TODO
	var i=0 
