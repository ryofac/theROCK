extends Actor
class_name Player
onready var my_sprite = get_node("Sprite")
var jump_impulse = 500.0
var inertia = 10.0
var index = 0;
var id = 0;


func _ready():
	pass


func _set_sprite(_velx, _vely):
	if _velx == 0 and _vely == 0:
		my_sprite.animation = "default"
	if _velx != 0:
		my_sprite.flip_h = sign(_velx) < 0
		if is_on_floor():
			my_sprite.animation = "running"
	if _vely < 0:
		my_sprite.animation = "jump"


func _physics_process(delta):
	_velocity.x = speed * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -jump_impulse
	_velocity =  move_and_slide(_velocity, FLOOR_NORMAL, false, 4, 0.785398, false)
	_set_sprite(_velocity.x, _velocity.y)
	
	

	var collided = $RayCast2D.get_collider()
	if collided:
		if collided.is_in_group("rock"):
			if !(self in Global.players_colliding):
				Global.players_colliding.append(self)	
		if collided.is_in_group("player"):
			if collided in Global.players_colliding:
				if not self in Global.players_colliding:
					Global.players_colliding.append(self)
	else:
		if self in Global.players_colliding:
			Global.players_colliding.erase(self)


func _on_Player_tree_exiting():
	if self in Global.players_colliding:
		Global.players_colliding.erase(self)
