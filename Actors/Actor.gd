extends KinematicBody2D
class_name Actor

export var _velocity: = Vector2.ZERO
export var speed: = 300.0
export var gravity: = 1000.0
var FLOOR_NORMAL = Vector2.UP

func _ready():
	pass
func _process(delta):
	_velocity.y += gravity * delta
