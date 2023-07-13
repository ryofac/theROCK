extends Actor
class_name Player
var jump_impulse = 500.0
var inertia = 10.0
var index = 0;
var id = 0;
var spriteIndex = 0
var dying = false

# TODO: Player com velocity y ocorrendo em Actor em Process, resolver

onready var my_sprites = [
	get_node("SpriteNinja"),
	get_node("SpriteFinn"),
	get_node("SpriteFrog")
]
onready var my_sprite = my_sprites[spriteIndex]
onready var camera = get_parent().get_node_or_null("TheRock/Camera2D")
var playerName = ""

func _ready() -> void:
	my_sprite = my_sprites[spriteIndex]
	for i in range(len(my_sprites)):
		my_sprites[i].visible = true if i == spriteIndex else false
	my_sprite.connect("animation_finished", self, "animation_finished")
	$Name.rect_global_position.y += 0 if Global.get_player_count() % 2 else -20
	

func animation_finished():
	if my_sprite.animation == "appearing":
		my_sprite.play("default")

func is_on_list():
	return self in Global.players_colliding
	

func removeFromSpawnList():
	var _control = get_parent().get_node("Controller")
	if self in _control.playersToSpawn:
		_control.playersToSpawn.erase(self)


func _physics_process(delta):
	$Name.text = playerName
	_velocity.x = speed if is_on_floor() else 0
	
	if my_sprite.animation == "appearing":
		_velocity.y = 0
	
	if not is_on_floor():
		var _spawnBorder = 48
		var _newX = camera.global_position.x - camera.zoom.x * 500 + _spawnBorder;
		global_position.x = max(_newX, global_position.x)
	

	elif global_position.y >= 600:
		# Pisei no chão, devo sair da lista de players a serem spawnados
		removeFromSpawnList()
	
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
			
	# Atribuir Sprite:
	if my_sprite.animation != "appearing":
		if is_on_list() and not dying: my_sprite.play("running")
		else:
			_set_sprite(_velocity.x, _velocity.y) 
	
	if position.y > 1000:
		removeFromSpawnList()
		self.kill()
	
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, false, 4, 0.785398, false)	


func _set_sprite(_velx, _vely):
	if dying:
		return
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
	dying = true
	print("Player de ID " + str(id) + " morto.")
	my_sprite.play("disappearing")
	yield(my_sprite, "animation_finished")
	_velocity = Vector2.ZERO
	self.queue_free()


func _on_activateCollisions_timeout() -> void:
	# Reativar colisões
	get_node("CollisionShape2D").disabled = false
