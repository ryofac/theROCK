extends Actor

class_name Player
onready var my_sprite = get_node("Sprite")
var jump_impulse = 500.0
var inertia = 10.0

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
	_velocity.x = speed
	_velocity =  move_and_slide(_velocity, FLOOR_NORMAL, false, 4, 0.785398, false)
	_set_sprite(_velocity.x, _velocity.y)
	for collider in get_slide_count():
		if collider is Rock:
			collider.apply_central_impulse(10)

