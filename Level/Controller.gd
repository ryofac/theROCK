extends Node


onready var rockNode = get_parent().get_node("TheRock")

export var frogScene : PackedScene
export var finnScene: PackedScene

var caiu = false
var nomes = ["Lívia", "Patrocínio", "Robervaldo", "Halyson", "Henrique", "RAPAIZ"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _spawn_player(player_name, _x, _y):
	var players = [frogScene.instance(), finnScene.instance()]
	var player = players[_random_index_from(player_name, players)]
	print(player)
	player.get_node("Label").text = player_name
	player.position.x = _x
	player.position.y = _y
	get_parent().add_child(player)
	
	
func _random_index_from(player_name, list):
	var sum = 0
	for charac in str(player_name):
		sum += ord(charac)
	print(sum)
	var result = sum % (len(list));
	print(result)
	return result
	
	
func _process(delta):
	if Input.is_action_just_pressed("spawn_player"):
		var nome = nomes[int(rand_range(0, len(nomes) - 1))]
		_spawn_player(nome, 0, rand_range(10, 200))
	if rockNode.velocity.y >= 0 and rockNode.is_on_floor() and not rockNode.caiu:
		print('Caí')
		rockNode.caiu = true
	
