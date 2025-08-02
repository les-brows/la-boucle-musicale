class_name Enemy
extends Node2D


func _init() -> void:
	Globals.beat_launched.connect(_on_beat_launched)


func _on_beat_launched(num_beat: int) -> void:
	pass
