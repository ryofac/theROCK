extends Actor
class_name Rock

export var LINEAR_VELOCITY = 2;
export var WEIGHT = 100;
var player_count = 0;
var velocity = Vector2.ZERO;
var caiu = false;


func _physics_process(delta):
	get_node("Label").text = "Player count: " + str(player_count) + "\nVelocity X: " + str(velocity.x)

	velocity.x = get_velocity_x(player_count)
	
	velocity.y += gravity * delta	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	


	

func get_velocity_x(player_count):
	var x = (player_count * LINEAR_VELOCITY);
	x  = clamp(x, 0, 500);
	return x
	


func _on_Area2D_area_entered(area):
	print('Increased!');
	player_count += 1;

func _on_Area2D_area_exited(area):
	print("Reduced!");
	player_count -= 1;
