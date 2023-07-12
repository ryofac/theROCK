extends Actor
class_name Player
var jump_impulse = 500.0
var inertia = 10.0
var index = 0;
var id = 0;
onready var my_sprite = get_node("Sprite")
# Vel = time * 

func _physics_process(delta):
	_velocity.x = speed * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if Input.is_action_just_pressed("jump") and is_on_floor():
		_velocity.y = -jump_impulse
	_velocity =  move_and_slide(_velocity, FLOOR_NORMAL, false, 4, 0.785398, false)

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
	_set_sprite(_velocity.x, _velocity.y)
	if position.y > 1000:
		self.kill()


func _set_sprite(_velx, _vely):
	if _velx == 0 and _vely == 0:
		my_sprite.play("default")
	if _velx != 0:
		my_sprite.flip_h = sign(_velx) < 0
		if is_on_floor():
			my_sprite.play("running")
	if _vely < 0:
		my_sprite.play("jump")

func _on_Player_tree_exiting():
	if self in Global.players_colliding:
		Global.players_colliding.erase(self)

func kill():
	my_sprite.play("disappearing")
	self.queue_free()

