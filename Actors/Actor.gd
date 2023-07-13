extends KinematicBody2D
class_name Actor

# Global Variables:
export var _velocity: = Vector2.ZERO
export var speed: = 300.0
export var gravity: = 1000.0
var FLOOR_NORMAL = Vector2.UP
var LINEAR_VELOCITY = 10
var players_colliding = []
var players_spawned = 0
var rock_velocity = 0


func get_players_colliding():
	return players_colliding


func get_player_count():
	return len(get_tree().get_nodes_in_group("player"))


func _ready():
	pass

# atribui velocidade baseada na quantidade de players ligados a pedra
func apply_impulse_velocity():
	return LINEAR_VELOCITY * len(Global.players_colliding)
	


func _process(delta):
	_velocity.y += gravity * delta
