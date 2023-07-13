extends TileMap

onready var rock = get_parent().get_node("TheRock")
onready var camera = rock.get_node("Camera2D")
var UPDATE_RATE = 32
var _terrains_created = 0


func _ready():
	for i in range(0, 3):
		for cell_x in range(-32, 32):
			_create_tile(cell_x, 20, 1) if i <= 0 else _create_tile(cell_x, 20 + i, 0)

func _process(delta):
	var posx = camera.global_position.x
#DEBUG: rock.get_node("Label").text = "CREATED TERRAINS: " + str(_terrains_created) + "\n POSX: " + str(posx)
	if floor(int(posx) / UPDATE_RATE) >= _terrains_created:
		adjust_terrain()
		_terrains_created += 1



func _on_Button_pressed():
	_create_tile(int(rand_range(10, 20)), int(rand_range(10, 20)))


func _create_tile(_x,_y, type=0):
	set_cell(_x, _y, type)


func _delete_tile(_x, _y):
	set_cell(_x, _y, -1)


func adjust_terrain():
	var CELL_SIZE = 32
	var posx = camera.global_position.x

	var cx = floor(posx / CELL_SIZE) # obtaining the current x position for the cel
	
	var border = 20 * camera.zoom.x

	# Delete 3 lines of BORDER tiles to the left:
	var TILE_LINES = 3 + floor(Global.get_player_count() / 5)
	for i in range(0, TILE_LINES):
		for cell_x in range(0, cx - border):
			_delete_tile(cell_x, 20) if i <= 0 else _delete_tile(cell_x, 20 + i)

	# Create 3 lines of BORDER tiles to the right:
	for i in range(0, TILE_LINES):
		for cell_x in range(cx, cx + border):
			_create_tile(cell_x, 20, 1) if i <= 0 else _create_tile(cell_x, 20 + i, 0)
		
		
	
	
