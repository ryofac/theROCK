extends Node

export var playerScene : PackedScene
onready var rockNode = get_parent().get_node("TheRock")
onready var camera = get_parent().get_node("TheRock/Camera2D")

export var finnNode: PackedScene
export var frogNode: PackedScene
export var ninjaNode: PackedScene
export var guyNode:  PackedScene


# SPAWN_PLAYER: _spawn_player


func _spawn_player(_x=camera.global_position.x - 500, _y=rand_range(camera.global_position.y - 100, camera.global_position.y - 200)):
	var name_list = ['Patro', 'Hermínio', 'Henrique', 'Lívia', 'Meireles', 'Ryan']
	var player_list = [finnNode, frogNode, ninjaNode, guyNode]
	var player = player_list[randi() % len(player_list)].instance()
	Global.players_spawned += 1	
	player.add_to_group("player")
	player.get_node("Label").text = name_list[randi() % len(name_list)]
	player.position.x = _x
	player.position.y = _y
	player.id = Global.players_spawned
	get_parent().add_child(player)
	
	
	
func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	var player_count = len(players)
	
	if player_count <= 50:
		if Input.is_action_just_pressed("spawn_player"):
			# Spawn player
			_spawn_player()
	get_parent().get_node("TheRock/Label").text += '\n Player count = ' + str(player_count) if player_count <= 50 else "\nNão pode haver mais que 50 jogadores!"
		
	if Input.is_action_just_pressed("delete_player"):
		delete_random_player(players)



func delete_random_player(player_list):
	if len(player_list) > 0:
		var random_player = player_list[randi() % len(player_list)]
		random_player.kill()
		
	
	
