extends Node2D

class_name Projectile

var curr_velocity = Vector2(0,0)

func _physics_process(delta: float) -> void:
	global_position += curr_velocity * delta
	global_rotation = curr_velocity.angle()

func set_velocity(target_velocity: Vector2):
	curr_velocity = target_velocity
