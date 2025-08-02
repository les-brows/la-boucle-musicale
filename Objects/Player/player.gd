extends CharacterBody2D

@export var speed = 200.0
@export var size: Vector2 
@export var move_factor : float = 0.2

var targetDir : Vector2 = Vector2(0, 0)
@export var inputManagerNode  :Node 
var curr_look : float = 0 
var real_velocity : Vector2
var push_force = 80.0

func _ready():
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
