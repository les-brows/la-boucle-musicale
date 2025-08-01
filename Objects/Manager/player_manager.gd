
extends Node2D

@export var inputManagerNode: Node

var res_player = preload("res://Objects/Player/Player.tscn")

var sprite: CompressedTexture2D =  load("res://Aseprite/Character_Green.png")


# TODO setup player positions with the map

func init_player_placement(nb_players) -> void:
		var player = res_player.instantiate()
		player.get_node("./PrincipalSprite").texture = sprite
		player.set_global_position(Vector2(randi_range(0, 100), randi_range(0, 100)))
		player.inputManager= inputManagerNode
		inputManagerNode.move_update.connect(player._on_player_move)
		inputManagerNode.shoot_update.connect(player._on_player_shoot)
		call_deferred("add_child", player)
