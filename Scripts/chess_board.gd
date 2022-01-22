extends Node2D

# Grid variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

var possible_pieces = [
	# White pieces
	preload("res://Chess Pieces/White Pieces/white_pawn.tscn"),
	preload("res://Chess Pieces/White Pieces/white_bishop.tscn"),
	preload("res://Chess Pieces/White Pieces/white_rook.tscn"),
	preload("res://Chess Pieces/White Pieces/white_king.tscn"),
	preload("res://Chess Pieces/White Pieces/white_knight.tscn"),
	preload("res://Chess Pieces/White Pieces/white_queen.tscn"),
	
	# Black pieces
	preload("res://Chess Pieces/Black Pieces/black_pawn.tscn"),
	preload("res://Chess Pieces/Black Pieces/black_bishop.tscn"),
	preload("res://Chess Pieces/Black Pieces/black_rook.tscn"),
	preload("res://Chess Pieces/Black Pieces/black_king.tscn"),
	preload("res://Chess Pieces/Black Pieces/black_knight.tscn"),
	preload("res://Chess Pieces/Black Pieces/black_queen.tscn")
]

var all_pieces = []
var piece_types = []
var white_turn = true

# Touch variables
var first_touch = Vector2(0,0)
var final_touch = Vector2(0,0)
var controlling = false
var movement_occured = false

# Mine set up
onready var BuyMine: Button = $BuyMine
onready var SetMine: Button = $SetMine
onready var dissolveTimer = $DissolveTimer
var button_pressed = 'Buy'
var black_mines = 0
var white_mines = 0

# Gold system
var black_gold = 0
var white_gold = 0
var chess_notations = {'A':0, 'B':1, 'C':2, 'D':3, 'E':4, 'F':5, 'G':6, 'H':7}
var piece_value = {'PAWN':1, 'KNIGHT':3, 'BISHOP':3, 'ROOK':5, 'QUEEN':9}


func _ready():
	all_pieces = make_2d_array()
	piece_types = make_2d_array()
	spawn_white_pieces()
	spaw_black_pieces()

func _process(_delta):
	touch_input()
	display_turn()
	display_instruction()
	
	# Display gold
	$WhiteGold_V.text = str(white_gold)
	$BlackGold_V.text = str(black_gold)
	
	# Display mines
	$WhiteMine_V.text = str(white_mines)
	$BlackMine_V.text = str(black_mines)



#________________All Functions________________
func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null)
	return array

func spawn_white_pieces():
	# spawn pawns
	for i in width:
		var pawn = possible_pieces[0].instance()
		add_child(pawn)
		pawn.position = grid_to_pixel(i, 1)
		all_pieces[i][1] = pawn
		piece_types[i][1] = "W_PAWN"
		
	# spawn rooks
	var rook1 = possible_pieces[2].instance()
	add_child(rook1)
	rook1.position = grid_to_pixel(0, 0)
	all_pieces[0][0] = rook1
	piece_types[0][0] = "W_ROOK"
	
	var rook2 = possible_pieces[2].instance()
	add_child(rook2)
	rook2.position = grid_to_pixel(7, 0)
	all_pieces[7][0] = rook2
	piece_types[7][0] = "W_ROOK"
	
	# spawn knights
	var knight1 = possible_pieces[4].instance()
	add_child(knight1)
	knight1.position = grid_to_pixel(1, 0)
	all_pieces[1][0] = knight1
	piece_types[1][0] = "W_KNIGHT"
	
	var knight2 = possible_pieces[4].instance()
	add_child(knight2)
	knight2.position = grid_to_pixel(6, 0)
	all_pieces[6][0] = knight2
	piece_types[6][0] = "W_KNIGHT"
	
	# spawn bishops
	var bishop1 = possible_pieces[1].instance()
	add_child(bishop1)
	bishop1.position = grid_to_pixel(2, 0)
	all_pieces[2][0] = bishop1
	piece_types[2][0] = "W_BISHOP"
	
	var bishop2 = possible_pieces[1].instance()
	add_child(bishop2)
	bishop2.position = grid_to_pixel(5, 0)
	all_pieces[5][0] = bishop2
	piece_types[5][0] = "W_BISHOP"
	
	# spawn queen
	var queen = possible_pieces[5].instance()
	add_child(queen)
	queen.position = grid_to_pixel(3, 0)
	all_pieces[3][0] = queen
	piece_types[3][0] = "W_QUEEN"
	
	# spawn king
	var king = possible_pieces[3].instance()
	add_child(king)
	king.position = grid_to_pixel(4, 0)
	all_pieces[4][0] = king
	piece_types[4][0] = "W_KING"

func spaw_black_pieces():
	# spawn pawns
	for i in width:
		var pawn = possible_pieces[6].instance()
		add_child(pawn)
		pawn.position = grid_to_pixel(i, 6)
		all_pieces[i][6] = pawn
		piece_types[i][6] = "B_PAWN"
		
	# spawn rooks
	var rook1 = possible_pieces[8].instance()
	add_child(rook1)
	rook1.position = grid_to_pixel(0, 7)
	all_pieces[0][7] = rook1
	piece_types[0][7] = "B_ROOK"
	
	var rook2 = possible_pieces[8].instance()
	add_child(rook2)
	rook2.position = grid_to_pixel(7, 7)
	all_pieces[7][7] = rook2
	piece_types[7][7] = "B_ROOK"
	
	# spawn knights
	var knight1 = possible_pieces[10].instance()
	add_child(knight1)
	knight1.position = grid_to_pixel(1, 7)
	all_pieces[1][7] = knight1
	piece_types[1][7] = "B_KNIGHT"
	
	var knight2 = possible_pieces[10].instance()
	add_child(knight2)
	knight2.position = grid_to_pixel(6, 7)
	all_pieces[6][7] = knight2
	piece_types[6][7] = "B_KNIGHT"
	
	# spawn bishops
	var bishop1 = possible_pieces[7].instance()
	add_child(bishop1)
	bishop1.position = grid_to_pixel(2, 7)
	all_pieces[2][7] = bishop1
	piece_types[2][7] = "B_BISHOP"
	
	var bishop2 = possible_pieces[7].instance()
	add_child(bishop2)
	bishop2.position = grid_to_pixel(5, 7)
	all_pieces[5][7] = bishop2
	piece_types[5][7] = "B_BISHOP"
	
	# spawn queen
	var queen = possible_pieces[11].instance()
	add_child(queen)
	queen.position = grid_to_pixel(3, 7)
	all_pieces[3][7] = queen
	piece_types[3][7] = "B_QUEEN"
	
	# spawn king
	var king = possible_pieces[9].instance()
	add_child(king)
	king.position = grid_to_pixel(4, 7)
	all_pieces[4][7] = king
	piece_types[4][7] = "B_KING"

func touch_input():
	movement_occured = false
	if Input.is_action_just_pressed("mouse_select"):
		first_touch = get_global_mouse_position()
		var grid_position = pixel_to_grid(first_touch.x, first_touch.y)
		if is_in_grid(grid_position.x, grid_position.y):
			controlling = true
	if Input.is_action_just_released("mouse_select"):
		final_touch = get_global_mouse_position()
		var grid_position = pixel_to_grid(final_touch.x, final_touch.y)
		if is_in_grid(grid_position.x, grid_position.y) and controlling:
			# moving pieces after touch
			var piece_position = pixel_to_grid(first_touch.x, first_touch.y)
			var target_position = pixel_to_grid(final_touch.x, final_touch.y)
			var direction = target_position - piece_position
			move_white_pieces(piece_position.x, piece_position.y, direction)
			move_black_pieces(piece_position.x, piece_position.y, direction)
			
			# changing turn
			if movement_occured:
				white_turn = not white_turn

func is_in_grid(column, row):
	if column >= 0 and column < width:
		if row >= 0 and row < height:
			return true
	return false

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func grid_to_pixel(column, row):
	var new_x = x_start + (offset * column)
	var new_y = y_start + (-offset * row)
	return Vector2(new_x, new_y)

func move_white_pieces(column, row, direction):
	var selected_piece = all_pieces[column][row]
	var selected_type = piece_types[column][row]
	var target_pos = all_pieces[column + direction.x][row + direction.y]
	var target_type = piece_types[column + direction.x][row + direction.y]
	
	# Logic
	if white_turn == true:
		move_w_pawn(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_w_knight(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_w_rook(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_w_bishop(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_w_queen(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_w_king(column, row, direction, selected_piece, target_pos, selected_type, target_type)

func move_black_pieces(column, row, direction):
	var selected_piece = all_pieces[column][row]
	var selected_type = piece_types[column][row]
	var target_pos = all_pieces[column + direction.x][row + direction.y]
	var target_type = piece_types[column + direction.x][row + direction.y]
	
	# Logic
	if white_turn == false:
		move_b_pawn(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_b_knight(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_b_rook(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_b_bishop(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_b_queen(column, row, direction, selected_piece, target_pos, selected_type, target_type)
		move_b_king(column, row, direction, selected_piece, target_pos, selected_type, target_type)

func display_turn():
	if white_turn == true:
		$WhiteTurn.visible = true
		$BlackTurn.visible = false
	elif white_turn == false:
		$WhiteTurn.visible = false
		$BlackTurn.visible = true


#________________Chess Movements________________
# Pawn movement
func move_w_pawn(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_PAWN":
		# move to empty space
		if target_pos == null and direction.x == 0:
			if (row == 1 and (direction.y == 1 or direction.y == 2)) or (row != 1 and direction.y == 1):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type) and (direction.x == 1 or direction.x == -1):
			if (row == 1 and (direction.y == 1 or direction.y == 2)) or (row != 1 and direction.y == 1):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and direction.x == 0:
			if (row == 1 and (direction.y == 1 or direction.y == 2)) or (row != 1 and direction.y == 1):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_pawn(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_PAWN":
		# move to empty space
		if target_pos == null and direction.x == 0:
			if (row == 6 and (direction.y == -1 or direction.y == -2)) or (row != 6 and direction.y == -1):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type) and (direction.x == 1 or direction.x == -1):
			if (row == 6 and (direction.y == -1 or direction.y == -2)) or (row != 6 and direction.y == -1):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and direction.x == 0:
			if (row == 6 and (direction.y == -1 or direction.y == -2)) or (row != 6 and direction.y == -1):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)


# Knight movement
func move_w_knight(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_KNIGHT":
		# move to empty space
		if target_pos == null:
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type):
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE'):
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_knight(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_KNIGHT":
		# move to empty space
		if target_pos == null:
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type):
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE'):
			if (abs(direction.x) == 1 and abs(direction.y) == 2) or (abs(direction.x) == 2 and abs(direction.y) == 1):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)


# Rook movement
func move_w_rook(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_ROOK":
		# move to empty space
		if target_pos == null and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type) and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_rook(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_ROOK":
		# move to empty space
		if target_pos == null and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type) and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and check_rook_path(column, row, direction):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)


# Bishop movement
func move_w_bishop(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_BISHOP":
		# move to empty space
		if target_pos == null and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type) and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_bishop(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_BISHOP":
		# move to empty space
		if target_pos == null and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type) and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and check_bishop_path(column, row, direction):
			if abs(direction.x) == abs(direction.y):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)


# Queen movement
func move_w_queen(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_QUEEN":
		# move to empty space
		if target_pos == null and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type) and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_queen(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_QUEEN":
		# move to empty space
		if target_pos == null and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type) and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE') and (check_rook_path(column, row, direction) and check_bishop_path(column, row, direction)):
			if (direction.x != 0 and direction.y == 0) or (direction.x == 0 and direction.y != 0) or (abs(direction.x) == abs(direction.y)):
				stepped_on_mine(column, row, direction, selected_piece, selected_type)


# King movement
func move_w_king(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "W_KING":
		# move to empty space
		if target_pos == null:
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("B_" in target_type):
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE'):
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

func move_b_king(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_KING":
		# move to empty space
		if target_pos == null:
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				move_piece(column, row, selected_piece, selected_type, direction)
		
		# kill enemy piece
		if (target_type != null) and ("W_" in target_type):
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				kill_enemy(column, row, direction, selected_piece, selected_type, target_pos)
				
				# Update gold
				gold_count(target_type)
				
		# Stepped on mine
		if (target_type == 'MINE'):
			if abs(direction.x) <= 1 and abs(direction.y) <= 1:
				stepped_on_mine(column, row, direction, selected_piece, selected_type)

# Checking paths
func check_rook_path(column, row, direction):
	var path = []
	
	if direction.x == 0:
		if direction.y > 0:
			for i in range(1, direction.y):
				path.append(piece_types[column][row+i])
		if direction.y < 0:
			for i in range(1, -direction.y):
				path.append(piece_types[column][row-i])
	
	if direction.y == 0:
		if direction.x > 0:
			for i in range(1, direction.x):
				path.append(piece_types[column+i][row])
		if direction.x < 0:
			for i in range(1, -direction.x):
				path.append(piece_types[column-i][row])
	 
	if path.count(null) == len(path):
		return true
	else:
		return false

func check_bishop_path(column, row, direction):
	var path = []
	var steps = abs(direction.x)
	
	if direction.x > 0 and direction.y > 0:
		for i in range(1, steps):
			path.append(piece_types[column+i][row+i])
	
	if direction.x > 0 and direction.y < 0:
		for i in range(1, steps):
			path.append(piece_types[column+i][row-i])
	
	if direction.x < 0 and direction.y > 0:
		for i in range(1, steps):
			path.append(piece_types[column-i][row+i])
			
	if direction.x < 0 and direction.y < 0:
		for i in range(1, steps):
			path.append(piece_types[column-i][row-i])
	 
	if path.count(null) == len(path):
		return true
	else:
		return false

# Promoting pawns
func promote_pawn():
	pass



#________________Getting gold, moving, exploding, and killing enemies________________
func gold_count(target_type):
	if white_turn == true:
		white_gold += piece_value[target_type.substr(2,len(target_type))]
	if white_turn == false:
		black_gold += piece_value[target_type.substr(2,len(target_type))]

func move_piece(column, row, selected_piece, selected_type, direction):
	# update the piece array
	all_pieces[column + direction.x][row + direction.y] = selected_piece
	all_pieces[column][row] = null
	
	# update the type array
	piece_types[column + direction.x][row + direction.y] = selected_type
	piece_types[column][row] = null
	
	# update the grid
	selected_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
	
	# Recognize movement to change turn
	movement_occured = true

func kill_enemy(column, row, direction, selected_piece, selected_type, target_pos):
	# update the piece array
	all_pieces[column + direction.x][row + direction.y] = selected_piece
	all_pieces[column][row] = null
	
	# update the type array
	piece_types[column + direction.x][row + direction.y] = selected_type
	piece_types[column][row] = null
	
	# update the grid
	target_pos.queue_free() # remove piece
	selected_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
	
	# Recognize movement to change turn
	movement_occured = true

func stepped_on_mine(column, row, direction, selected_piece, selected_type):
	# update the piece array
	all_pieces[column + direction.x][row + direction.y] = selected_piece
	all_pieces[column][row] = null
	
	# update the type array
	piece_types[column + direction.x][row + direction.y] = null
	piece_types[column][row] = null
	
	# update the grid
	selected_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
	selected_piece.dissolve() # dissolve piece
	
	# wait for some time before removing
	dissolveTimer.start()
	yield(dissolveTimer, "timeout")
	
	# remove piece
	selected_piece.queue_free() # remove piece
	all_pieces[column + direction.x][row + direction.y] = null 
	
	# updating gold
	if white_turn == true:
		white_gold += piece_value[selected_type.substr(2,len(selected_type))]
	if white_turn == false:
		black_gold += piece_value[selected_type.substr(2,len(selected_type))]
	
	# recognize movement to change turn
	movement_occured = true




#________________Buying and Setting Mines________________
func _on_BuyMine_pressed() -> void:
	button_pressed = 'Buy'

func _on_SetMine_pressed() -> void:
	button_pressed = 'Set'

func _on_Input_text_entered(new_text: String) -> void:
	# Buying mines
	if (button_pressed == 'Buy')  and new_text.is_valid_integer():
		if white_turn == true and (3*int(new_text)) <= white_gold:
			white_mines += int(new_text)
			white_gold  -= 3*int(new_text)
			# Clear input box
			$InputArea/Input.clear()
		if white_turn == false and (3*int(new_text)) <= black_gold:
			black_mines += int(new_text)
			black_gold  -= 3*int(new_text)
			# Clear input box
			$InputArea/Input.clear()
	
	# Seting mines
	if button_pressed == 'Set' and (len(new_text) == 2)and (new_text[0].to_upper() in 'ABCDEFGH') and (new_text[1] in '12345678'):
		var text = new_text.to_upper()
		var target_pos  = all_pieces[chess_notations[text[0]]][int(text[1]) -1]
		
		# Check if tile is empty and set mine
		if target_pos == null:
			# Update number of mines
			if white_turn == true and white_mines > 0:
				white_mines -= 1
				piece_types[chess_notations[text[0]]][int(text[1]) -1] = 'MINE'
				$InputArea/Input.clear()
			if white_turn == false and black_mines > 0:
				black_mines -= 1
				piece_types[chess_notations[text[0]]][int(text[1]) -1] = 'MINE'
				$InputArea/Input.clear()

func display_instruction():
	if button_pressed == 'Buy':
		$MinesInstruction.visible = true
		$TileInstruction.visible = false
	if button_pressed == 'Set':
		$MinesInstruction.visible = false
		$TileInstruction.visible = true

