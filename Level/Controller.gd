extends Node

export var playerScene : PackedScene

onready var rockNode = get_parent().get_node("TheRock")
onready var camera = get_parent().get_node("TheRock/Camera2D")


func _spawn_player(_x, _y):
	var player = playerScene.instance()
	Global.players_spawned += 1	
	player.add_to_group("player")
	player.position.x = _x
	player.position.y = _y
	player.id = Global.players_spawned
	player.get_node("Label").text = "MY ID: " + str(player.id)
	get_parent().add_child(player)
	
	
	
func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	var player_count = len(players)
	
	if player_count <= 50:
		if Input.is_action_just_pressed("spawn_player"):
			# Spawn player
			_spawn_player(rand_range(camera.global_position.x - 200, camera.global_position.x - 400), rand_range(camera.global_position.y - 100, camera.global_position.y - 200))
	else:
		print("Não pode haver mais de 50 players na tela!")	
	get_parent().get_node("TheRock/Label").text += '\n Player count = ' + str(player_count) if player_count <= 50 else "\nNão pode haver mais que 50 jogadores!"
		
	if Input.is_action_just_pressed("delete_player"):
		delete_random_player(players)



func delete_random_player(player_list):
	if len(player_list) > 0:
		player_list[randi() % len(player_list)].queue_free()
		
	
	
