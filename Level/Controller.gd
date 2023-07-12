extends Node

export var playerScene: PackedScene
export var websocketScene: PackedScene

onready var tileMap = get_parent().get_node("TileMap")
onready var rockNode = get_parent().get_node("TheRock")
onready var canvasNode = get_parent().get_node("CanvasLayer/MainScreen")
onready var camera = get_parent().get_node("TheRock/Camera2D")
onready var players = get_tree().get_nodes_in_group("player")
onready var player_count = len(players)
var playersToSpawn = []




func _ready() -> void:
	var webs = websocketScene.instance()
	get_parent().call_deferred("add_child", webs)
#	call_deferred("get_parent().add_child(webs)")
	print(webs)
	

func _spawn_player(_x=null, _y=null):
	if (_x == null):
		_x = camera.global_position.x - 500 * camera.zoom.x
	if (_y == null):
		_y = camera.global_position.y - 240 * camera.zoom.y
	var name_list = ['Patro', 'Hermínio', 'Henrique', 'Lívia', 'Meireles', 'Ryan']
		
	var player = playerScene.instance()
	Global.players_spawned += 1	
	player.add_to_group("player")
#	player.get_node("Name").text = name_list[randi() % len(name_list)]
	player.position.x = _x
	player.position.y = _y
	player.id = Global.players_spawned
	player.spriteIndex = randi() % 3
	player.set_process(false)
	playersToSpawn.append(player)
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
			var _pl = _spawn_player()
	# Permitir movimento apenas do primeiro jogador a ser spawnado.
	if len(playersToSpawn) > 0:
		playersToSpawn[0].set_process(true)
		var _timer = playersToSpawn[0].get_node("activateCollisions")
		if _timer.is_stopped():
			_timer.start()
		
	adjust_zoom(players)
	debug(players)



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

func show_qrcode():
	var webs = get_parent().get_node("WebSocket")
	canvasNode.get_node("qrcode").visible = webs.is_online()

func debug(players):
	if Input.is_action_just_pressed("delete_player"):
		delete_random_player(players)
	if Input.is_action_just_pressed("force_zoom_in"):
		camera.zoom.x += 1
		camera.zoom.y += 1
	if Input.is_action_just_pressed("force_zoom_out"):
		camera.zoom.x -= 1
		camera.zoom.y -= 1

	
