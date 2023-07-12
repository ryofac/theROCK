extends Actor
class_name Rock

var velocity = Vector2.ZERO
var stopped = velocity.x == 0
export var WEIGHT = 200;

# vel =


func _physics_process(delta):
	$Label.text = "\nVelocity X: " + str(velocity.x)
	$Label.text += '\n Players colliding: ' + str(len(Global.players_colliding))

	var collider = $RayCast2D.get_collider()
	if not collider:
		Global.players_colliding = []
	velocity.y += gravity * delta
	
	# ======= APROACH VELOCITY ======= => move_towards manuals
	var _newVel = 0
	
	if len(Global.players_colliding) > 1: # "Static Atrite"
		_newVel = apply_impulse_velocity();
		
	var _dif = abs(_newVel - velocity.x);
	var _sign = sign(_newVel - velocity.x)
	var _acc = 10 if _sign > 0 else 1
	if (_dif > _acc):
		velocity.x += _acc * _sign
	else:
		velocity.x = _newVel
		
		
	apply_rotation(velocity.x)
	Global.rock_velocity = velocity.x
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_rotation(velocity_x):
	if velocity_x > 0:
		$RockSprite.rotation_degrees += 0.05 * velocity_x

	


	
