extends TileMap

var UPDATE_RATE = 30

func _ready():
	for i in range(0, 3):
		for cell_x in range(0, 32):
			_create_tile(cell_x, 20, 1) if i <= 0 else _create_tile(cell_x, 20 + i, 0)

func _process(delta):
	var posx = get_node("TheRock/Camera2D").global_position.x
	if int(posx) % UPDATE_RATE == 0: # Updates the tiles under the rock
		adjust_terrain()



func _on_Button_pressed():
	_create_tile(int(rand_range(10, 20)), int(rand_range(10, 20)))


func _create_tile(_x,_y, type=0):
	set_cell(_x, _y, type)


func _delete_tile(_x, _y):
	set_cell(_x, _y, -1)


func adjust_terrain():
	var CELL_SIZE = 32
	var posx = get_node("TheRock/Camera2D").global_position.x

	var cx = floor(posx / CELL_SIZE) # obtaining the current x position for the cel
	
	var border = get_node("TheRock").velocity.x / 2
	
	# Delete 3 lines of BORDER tiles to the left:
	for i in range(0, 4):
		for cell_x in range(0, cx - border):
			_delete_tile(cell_x, 20) if i <= 0 else _delete_tile(cell_x, 20 + i)

	# Create 3 lines of BORDER tiles to the right:
	for i in range(0, 4):
		for cell_x in range(cx, cx + border):
			_create_tile(cell_x, 20, 1) if i <= 0 else _create_tile(cell_x, 20 + i, 0)
		
		
	
	
