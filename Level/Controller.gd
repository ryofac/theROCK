extends Node
var rockNode : Node
export var playerScene : PackedScene

onready var camera = get_parent().get_node("TheRock/Camera2D")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _spawn_player(_x, _y):
	Global.players_spawned += 1
	var player = playerScene.instance()
	player.add_to_group("player")
	player.position.x = _x
	player.position.y = _y
	player.id = Global.players_spawned
	player.get_node("Label").text = "MY ID: " + str(player.id)
	get_parent().add_child(player)
	
	
	
func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	if Input.is_action_just_pressed("spawn_player"):
		_spawn_player(rand_range(camera.global_position.x - 200, camera.global_position.x - 400), rand_range(camera.global_position.y - 100, camera.global_position.y - 200))
	if Input.is_action_just_pressed("delete_player"):
		print(players)
		delete_random_player(players)


func delete_random_player(player_list):
	if len(player_list) > 0:
		player_list[randi() % len(player_list)].queue_free()
		

	
	
