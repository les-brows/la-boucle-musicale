extends Node2D

func _on_middle_line_body_entered(_body: Node2D) -> void:
	Globals.middle_level_reached.emit()

func _on_end_line_body_entered(_body: Node2D) -> void:
	Globals.end_level_reached.emit()
