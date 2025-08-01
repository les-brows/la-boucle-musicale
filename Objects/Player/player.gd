extends CharacterBody2D

@export var speed = 200.0
@export var size: Vector2 

func _ready():
	size = $CollisionShape2D.shape.size

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("player1_right"):
		direction.x += 1
	if Input.is_action_pressed("player1_left"):
		direction.x -= 1
	if Input.is_action_pressed("player1_down"):
		direction.y += 1
	if Input.is_action_pressed("player1_up"):
		direction.y -= 1

	# Normalize direction to prevent faster diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

	velocity = direction * speed
	move_and_slide()
