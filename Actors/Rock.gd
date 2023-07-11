extends Actor
class_name Rock

var velocity = Vector2.ZERO


func _physics_process(delta):
	$Label.text = "\nVelocity X: " + str(velocity.x)
	$Label.text += '\n Players colliding: ' + str(len(Global.players_colliding))
	apply_rotation(velocity.x)
	var collider = $RayCast2D.get_collider()
	if not collider:
		Global.players_colliding = []
	velocity.y += gravity * delta
	
	# ======= APROACH VELOCITY ======= => move_towards manual
	var _newVel = apply_impulse_velocity();
	var _dif = abs(_newVel - velocity.x);
	var _sign = sign(_newVel - velocity.x)
	var _acc = 5 if _sign > 0 else 1
	if (_dif > _acc):
		velocity.x += _acc * _sign
	else:
		velocity.x = _newVel
	
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_rotation(velocity_x):
	if velocity_x > 0:
		$RockSprite.rotation_degrees += 0.05 * velocity_x

	


	
