extends Node

export var playerScene: PackedScene
export var websocketScene: PackedScene

onready var tileMap = get_parent().get_node("TileMap")
onready var rockNode = get_parent().get_node("TheRock")
onready var canvasNode = get_parent().get_node("GUI/MainScreen")
onready var camera = get_parent().get_node("TheRock/Camera2D")
onready var players = get_tree().get_nodes_in_group("player")

onready var qr_sprite = canvasNode.get_node("qrcode")
var animation_times_played = 0
var hided = false
	
onready var player_count = len(players)
var playersToSpawn = []


func _ready() -> void:
	var webs = websocketScene.instance()
	get_parent().call_deferred("add_child", webs)
	print(webs)
	qr_sprite.position.x = 300
	qr_sprite.position.y = 273
	
	
func _process(delta):
	var players = get_tree().get_nodes_in_group("player")
	var player_count = len(players)
	if player_count <= 50:
		if Input.is_action_just_pressed("spawn_player"):
			var _pl = _spawn_player()
			_pl.set_process(false)
			
			
	# Permitir movimento apenas do primeiro jogador a ser spawnado.
	if len(playersToSpawn) > 0:
		playersToSpawn[0].set_process(true)
		var _timer = playersToSpawn[0].get_node("activateCollisions")
		if _timer.is_stopped():
			_timer.start()
	
	show_qrcode()
	adjust_zoom(players)
	debug(players)
	animate_qr_code()

func _spawn_player(_x=null, _y=null, name="Player"):
	if (_x == null):
		_x = camera.global_position.x - 600 * max(camera.zoom.x, Global.get_player_count())
		
	if (_y == null):
		_y = camera.global_position.y - 240 * camera.zoom.y

		
	var player = playerScene.instance()
	Global.players_spawned += 1	
	player.add_to_group("player")
	player.position.x = _x
	player.position.y = _y
	player.playerName = name
	player.id = Global.players_spawned
	player.spriteIndex = randi() % 3
	playersToSpawn.append(player)
	get_parent().add_child(player)
	print("Player instanciado na posicao: " + str(_x) + " e " + str(_y))
	return player


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
	
	canvasNode.get_node("header").text = "A... Rock?" if Global.get_player_count() <= 0 else "Escaneie também o QRCODE!"
	var webs = get_parent().get_node("WebSocket")
	if webs.is_online() and not webs.is_offline():
		qr_sprite.visible = true
		qr_sprite.modulate = Color(1, 1, 1, 1)
		qr_sprite.get_node("ColorRect").visible = false
		qr_sprite.get_node("Conecte-se!").text = "Conecte-se"
		
	if webs.is_offline():
		qr_sprite.modulate = Color(1, 0, 0, 0.5)
		qr_sprite.get_node("ColorRect").visible = true
		qr_sprite.get_node("Conecte-se!").text = "OFFLINE"
		
	if webs.is_connecting():
		qr_sprite.modulate = Color(1, 1, 0, 0.5)
		qr_sprite.get_node("Conecte-se!").text = "Tentando conectar..."
		

func animate_qr_code():
	if Global.get_player_count() > 0:
		if hided:
			return
		canvasNode.get_node("Animator").play("HideQrCode")
		hided = true
		
	if Global.get_player_count() <= 0:
		if not hided:
			return
		canvasNode.get_node("Animator").play_backwards("HideQrCode")
		hided = false


	
	
		
	
		
func check_fullscreen():
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
func debug(players):
	if Input.is_action_just_pressed("delete_player"):
		delete_random_player(players)
	if Input.is_action_just_pressed("force_zoom_in"):
		camera.zoom.x += 1
		camera.zoom.y += 1
	if Input.is_action_just_pressed("force_zoom_out"):
		camera.zoom.x -= 1
		camera.zoom.y -= 1
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func debug_print(text, line):
	print("DEBUG: " + str(text) + "LINE: " + str(line))
