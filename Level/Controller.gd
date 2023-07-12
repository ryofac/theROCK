extends Node

export var playerScene : PackedScene
onready var tileMap = get_parent().get_node("TileMap")
onready var rockNode = get_parent().get_node("TheRock")
onready var camera = get_parent().get_node("TheRock/Camera2D")

export var finnNode: PackedScene
export var frogNode: PackedScene
export var ninjaNode: PackedScene
export var guyNode:  PackedScene
export var websocket: PackedScene


# SPAWN_PLAYER: _spawn_player


func _ready() -> void:
	var _ws = websocket.instance()
	self.add_child(_ws)
	print("Websocket instanciado: " + str(_ws))
	


func _spawn_player(_x=null, _y=null):
	if (_x == null):
		_x = camera.global_position.x - 500 * camera.zoom.x
	if (_y == null):
		_y = camera.global_position.y - 240 * camera.zoom.y
	var name_list = ['Patro', 'Hermínio', 'Henrique', 'Lívia', 'Meireles', 'Ryan']
	var player_list = [finnNode, frogNode, ninjaNode]
	var player = player_list[randi() % len(player_list)].instance()
	Global.players_spawned += 1	
	player.add_to_group("player")
	player.get_node("Label").text = name_list[randi() % len(name_list)]
	player.position.x = _x
	player.position.y = _y
	var _spawnBorder = 48
	player.global_position.x = camera.global_position.x - camera.zoom.x * 500 + _spawnBorder
	player.id = Global.players_spawned
	get_parent().add_child(player)
	print("Player instanciado na posicao: " + str(_x) + " e " + str(_y))
	return player
	
	
	
func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	var player_count = len(players)
	
	if player_count <= 50:
		if Input.is_action_just_pressed("spawn_player"):
			print('Tentando spwanar')
			# Spawn player
			_spawn_player()
#	get_parent().get_node("TheRock/Label").text += '\n Player count = ' + str(player_count) if player_count <= 50 else "\nNão pode haver mais que 50 jogadores!"
		
	if Input.is_action_just_pressed("delete_player"):
		delete_random_player(players)
	adjust_zoom(players)



func delete_random_player(player_list):
	if len(player_list) > 0:
		var random_player = player_list[randi() % len(player_list)]
		random_player.kill()
		
func adjust_zoom(player_list):
	var start_zoom = 0.8
	var factor_zoom = floor(len(player_list) / 10) * 0.1
	var _newZoom = start_zoom + factor_zoom
	var _actualZoom = camera.zoom.x
	var _diff = (_newZoom - _actualZoom)
	var _vel = 0.025
	if abs(_diff) > _vel: 
		_actualZoom += _vel * sign(_diff)
	else:
		_actualZoom = _newZoom
	camera.zoom = Vector2(_actualZoom, _actualZoom)
	camera.global_position.y = 550 - _actualZoom * 100
	camera.limit_bottom = start_zoom * 1000 + 80 * _actualZoom
	
