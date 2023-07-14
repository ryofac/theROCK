extends Actor
class_name Rock

var velocity = Vector2.ZERO
var stopped = velocity.x == 0
export var WEIGHT = 20;
export var ATRITE = 2;
onready var INIT_POS = global_position.x
var current_text = ''
onready var particles = get_node("Particles")


func _ready():
	pass

func _physics_process(delta):
	
	# control of text
	$Label.text = current_text
	# Obtaining the feedback for the distance
	var distance_traveled = calculate_distance_travel(INIT_POS)
	
	if $IdleTimer.is_stopped():
		$Label.rect_scale = Vector2(2,2)
		show_distance(distance_traveled)
		
	# Cleaning players_colliding list if no one is touching the rock
	var collider = $RayCast2D.get_collider()
	if not collider:
		Global.players_colliding = []
		$IdleTimer.start() if $IdleTimer.is_stopped() else ""
	else:
		$IdleTimer.stop()
		
	velocity.y += gravity * delta
	
	var force_applyed = LINEAR_VELOCITY * len(Global.players_colliding) # Simulate Physics
	# ======= APROACH VELOCITY ======= => move_towards manuals
	var _newVel = 0
	if len(Global.players_colliding) > 1: # "Static Atrite"
		_newVel = apply_impulse_velocity();
		
	var _dif = abs(_newVel - velocity.x);
	var _sign = sign(_newVel - velocity.x)
	var _acc = force_applyed / WEIGHT if _sign > 0 else ATRITE
	if (_dif > _acc):
		velocity.x += _acc * _sign
	else:
		velocity.x = _newVel
	apply_rotation(velocity.x)
	Global.rock_velocity = velocity.x
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Manage Particles


func apply_rotation(velocity_x):
	if velocity_x > 0:
		$RockSprite.rotation_degrees += 0.01 * velocity_x

func calculate_distance_travel(init_position):
	return abs(global_position.x - init_position) / 100
	

func apply_text(text):
	$Label.text = '\n' + str(text)
	
func show_distance(distance_traveled):
	if distance_traveled > 1000:
		current_text = str(distance_traveled % 1000) + 'km'
	else:
		current_text = str(int(distance_traveled)) + 'm'
		
	# Animations
	if int(distance_traveled) % 100 == 0 and distance_traveled > 2:
		$Animator.play("strech_text_100")
	elif int(distance_traveled) % 10 == 0 and distance_traveled > 2:
		$Animator.play("strech_text")
		

func _on_IdleTimer_timeout():
	var cool_sentences = ["A qualquer momento...", 
	"\nSempre foi silencioso aqui?", "Comida tá demorando né?\n Que tal me EMPURRAR!?",
	"\nTomara que hoje tenha feijoada...", "Cara, queria poder comer \n como voces...",
	"Gostando de me empurrar? \nMe avalie!"]
	var choice =  cool_sentences[randi() % len(cool_sentences)]
	current_text = choice
	$Label.rect_scale = Vector2(1, 1)
	$Animator.play("idle_time")

	
