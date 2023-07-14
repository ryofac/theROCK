extends Node

# Inicializar Cliente Websocket
var _client = WebSocketClient.new()
export var _url = "wss://websockets-echo-rana.onrender.com/:4999"

# Obter referência do player que será spawnado
export var playerScene: PackedScene
export var QRCodeSprite: Texture
onready var qrcode = get_node_or_null("qrcode")
onready var header = get_node_or_null("header")
onready var debugLabel = get_node_or_null("debug")
onready var controller = get_parent().get_node("Controller")



func debugText(_text):
	if typeof(_text) != TYPE_STRING: _text = str(_text)
	print(_text)
	if (debugLabel != null): debugLabel.text += _text + '\n'


func spawnPlayer(_x, _y):
	var _newPlayer = playerScene.instance()
	_newPlayer.add_to_group("Players")
	_newPlayer.position = Vector2(_x, _y)
	get_parent().add_child(_newPlayer)
	return _newPlayer


func _ready():
	debugText("Iniciando conexão...")
	
	# Atribuir sprite do QR Code
#	qrcode.texture = QRCodeSprite
	
	# Definir funções de callback para cada evento:
	_client.connect("data_received", self, "data_received")
	_client.connect("connection_established", self, "connection_established")
	_client.connect("connection_closed", self, "connection_closed")
	
	
	# Conferir eventuais erros, e interromper processo caso haja:
	var _err = _client.connect_to_url(_url)
	if _err != OK:
		set_process(false)
		debugText("Falha ao conectar.")
		
func _process(_delta):
	# Receber eventos de network.
	_client.poll()

func connection_established(_subProtocol):
	debugText("Conexão estabelecida!")
	
func connection_closed(_clean):
	debugText("Conexão encerrada.")
	if _clean: debugText("De maneira limpa.")
	
	
func data_received():
	var payload = _client.get_peer(1).get_packet().get_string_from_utf8()
	debugText("Dados recebidos: " + str(payload))
	
	# Desempacotar
	var _package = JSON.parse(payload)
	var _p = _package.result
	
	# Rejeitar o pacote caso possua erros
	if _package.error != OK:
		debugText("Pacote com erro.")
		return
	# Encomenda sem avarias, pode receber do carteiro.
	else:	
		if _p.command == "PLAYER_LOGIN":
			debugText("Invocando personagem: " + str(_p.values.name))
			var _player = controller._spawn_player(rand_range(100, 300), 0, _p.values.name)


# Função de enviar mensagem - não utilizada
func send(msg):
	debugText("Enviando mensagem:\n")
	debugText(JSON.print(msg))
	_client.get_peer(1).put_packet(JSON.print(msg).to_utf8())
	
func is_online():
	return _client.get_connection_status() == 2
	
func is_conneting():
	return _client.get_connection_status() == 1

func is_offline():
	return _client.get_connection_status() == 0




# Reiniciar Jogo ao apertar botão
#func _on_Button_pressed() -> void:
#	# Deletar todos os Players
#	var players = get_tree().get_nodes_in_group("Players")
#	for player in players:
#		player.queue_free()
#
#	# Reiniciar jogo
#	if get_tree().reload_current_scene() == OK:
#		print("Reiniciando jogo.")
