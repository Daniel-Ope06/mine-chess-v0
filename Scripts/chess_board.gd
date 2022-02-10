extends Node2D

# Grid variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset

# Loading in needed scenes
const possible_pieces = [
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

const gameOverScreen = preload("res://UI/GameOverScreen.tscn")

# creating empty arrays and turn counter
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
var piece_value = {'PAWN':1, 'KNIGHT':3, 'BISHOP':3, 'ROOK':5, 'QUEEN':9, 'KING':0}


func _ready():
	all_pieces = make_2d_array()
	piece_types = make_2d_array()
	spawn_white_pieces()
	spaw_black_pieces()
	
	# Hide labels
	$WhiteInCheck.visible = false
	$WhiteInCheckmate.visible = false
	$BlackInCheck.visible = false
	$BlackInCheckmate.visible = false

func _process(_delta):
	touch_input()
	display_turn()
	display_instruction()
	display_check_and_checkmate()
	
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

func find_index(piece):
	for i in range(piece_types.size()):
		for j in range(piece_types.size()):
			if piece_types[i][j] == piece:
				return(Vector2(i,j))

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

func display_check_and_checkmate():
	var w_king_pos = find_index('W_KING')
	var b_king_pos = find_index('B_KING')
	
	if (w_king_pos != null) and (b_king_pos != null):
		# show check
		if (white_in_check(w_king_pos.x, w_king_pos.y)) and not(white_in_checkmate(w_king_pos.x, w_king_pos.y)):
			$WhiteInCheck.visible = true
		if (black_in_check(b_king_pos.x, b_king_pos.y)) and not(black_in_checkmate(b_king_pos.x, b_king_pos.y)):
			$BlackInCheck.visible = true
			
		# remove check
		if not(white_in_check(w_king_pos.x, w_king_pos.y)) and not(white_in_checkmate(w_king_pos.x, w_king_pos.y)):
			$WhiteInCheck.visible = false
		if not(black_in_check(b_king_pos.x, b_king_pos.y)) and not(black_in_checkmate(b_king_pos.x, b_king_pos.y)):
			$BlackInCheck.visible = false
		
		
		# show checkmate
		if (white_in_checkmate(w_king_pos.x, w_king_pos.y)):
			$WhiteInCheckmate.visible = true
			# wait for some time before showing game over screen
			yield(get_tree().create_timer(2.0), "timeout")
			var game_over = gameOverScreen.instance()
			add_child(game_over)
			game_over.set_winner(false)
			get_tree().paused = true
		if (black_in_checkmate(b_king_pos.x, b_king_pos.y)):
			$BlackInCheckmate.visible = true
			# wait for some time before showing game over screen
			yield(get_tree().create_timer(2.0), "timeout")
			var game_over = gameOverScreen.instance()
			add_child(game_over)
			game_over.set_winner(true)
			get_tree().paused = true



#________________Chess Movements________________
# Pawn movement
func move_w_pawn(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	var w_king_pos = find_index('W_KING')
	var b_king_pos = find_index('B_KING')
	
	if selected_type == "W_PAWN":
		# move to empty space
		if target_pos == null and direction.x == 0:
			if (row == 1 and (direction.y == 1 or direction.y == 2)) or (row != 1 and direction.y == 1):
				move_piece(column, row, selected_piece, selected_type, direction)
				#undo_invalid_move_in_check(column, row, selected_piece, selected_type, target_pos, direction)
		
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
	if selected_type == "W_KING" and not(white_in_check(column+direction.x, row+direction.y)):
		# move to empty space
		if (target_pos == null) and not(white_in_check(column+direction.x, row+direction.y)):
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
				
				# wait for some time before showing game over screen
				yield(get_tree().create_timer(2.0), "timeout")
				var game_over = gameOverScreen.instance()
				add_child(game_over)
				game_over.set_winner(false)
			
		# Castling
		if (target_pos == null) and (column == 4) and (row == 0):
			# king side castling
			if (direction.x == 2) and (piece_types[7][0] == 'W_ROOK') and check_castling(column, row, direction) and not(white_in_check(column+1, row)) and not(white_in_check(column+2, row)):
				# move king
				move_piece(column, row, selected_piece, selected_type, direction)
				
				# move rook
				move_piece(7, 0, all_pieces[7][0], piece_types[7][0], Vector2(-2, 0))
				
			# queen side castling
			if (direction.x == -2) and (piece_types[0][0] == 'W_ROOK') and check_castling(column, row, direction) and not(white_in_check(column-1, row)) and not(white_in_check(column-2, row)):
				# move king
				move_piece(column, row, selected_piece, selected_type, direction)
				
				# move rook
				move_piece(0, 0, all_pieces[0][0], piece_types[0][0], Vector2(3, 0))

func move_b_king(column, row, direction, selected_piece, target_pos, selected_type, target_type):
	if selected_type == "B_KING" and not(black_in_check(column+direction.x, row+direction.y)):
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
				
				# wait for some time before showing game over screen
				yield(get_tree().create_timer(2.0), "timeout")
				var game_over = gameOverScreen.instance()
				add_child(game_over)
				game_over.set_winner(true)
		
		# Castling
		if (target_pos == null) and (column == 4) and (row == 7):
			# king side castling
			if (direction.x == 2) and (piece_types[7][7] == 'B_ROOK') and check_castling(column, row, direction) and not(black_in_check(column+1, row)) and not(black_in_check(column+2, row)):
				# move king
				move_piece(column, row, selected_piece, selected_type, direction)
				
				# move rook
				move_piece(7, 7, all_pieces[7][7], piece_types[7][7], Vector2(-2, 0))
				
			# queen side castling
			if (direction.x == -2) and (piece_types[0][7] == 'B_ROOK') and check_castling(column, row, direction) and not(black_in_check(column-1, row)) and not(black_in_check(column-2, row)):
				# move king
				move_piece(column, row, selected_piece, selected_type, direction)
				
				# move rook
				move_piece(0, 7, all_pieces[0][7], piece_types[0][7], Vector2(3, 0))


#________________Checking conditions________________
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

func check_castling(column, row, direction):
	var path = []
	
	if direction.x == 2:
		for i in range(1, 3):
			path.append(piece_types[column+i][row])
			
	if direction.x == -2:
		for i in range(1, 3):
			path.append(piece_types[column-i][row])
	
	if path.count(null) == len(path):
		return true
	else:
		return false

func white_in_check(column, row):
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])
	
	
	# checking if white in check
	# checking for rook and queen attacks
	if ('B_ROOK' in path_up) or ('B_ROOK' in path_down) or ('B_ROOK' in path_left) or ('B_ROOK' in path_right) or ('B_QUEEN' in path_up) or ('B_QUEEN' in path_down) or ('B_QUEEN' in path_left) or ('B_QUEEN' in path_right):
		return true
		
	# checkign for bishop and queen
	if ('B_BISHOP' in path_up_left) or ('B_BISHOP' in path_up_right) or ('B_BISHOP' in path_down_left) or ('B_BISHOP' in path_down_right) or ('B_QUEEN' in path_up_left) or ('B_QUEEN' in path_up_right) or ('B_QUEEN' in path_down_left) or ('B_QUEEN' in path_down_right):
		return true
	
	 # checking for knight attacks
	if ('B_KNIGHT' in path_knights):
		return true
	
	# checking for pawn attacks
	if len(path_up_left) > 1:
		if path_up_left[1] == 'B_PAWN':
			return true
			
	if len(path_up_right) > 1:
		if path_up_right[1] == 'B_PAWN':
			return true
	
	if len(path_down_left) > 1:
		if path_down_left[1] == 'B_PAWN':
			return true
	
	if len(path_down_right) > 1:
		if path_down_right[1] == 'B_PAWN':
			return true

func black_in_check(column, row):
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])
	
	
# checking if black in check
	# checking for rook and queen attacks
	if ('W_ROOK' in path_up) or ('W_ROOK' in path_down) or ('W_ROOK' in path_left) or ('W_ROOK' in path_right) or ('W_QUEEN' in path_up) or ('W_QUEEN' in path_down) or ('W_QUEEN' in path_left) or ('W_QUEEN' in path_right):
		return true
		
	# checkign for bishop and queen
	if ('W_BISHOP' in path_up_left) or ('W_BISHOP' in path_up_right) or ('W_BISHOP' in path_down_left) or ('W_BISHOP' in path_down_right) or ('W_QUEEN' in path_up_left) or ('W_QUEEN' in path_up_right) or ('W_QUEEN' in path_down_left) or ('W_QUEEN' in path_down_right):
		return true
	
	 # checking for knight attacks
	if ('W_KNIGHT' in path_knights):
		return true
	
	# checking for pawn attacks
	if len(path_up_left) > 1:
		if path_up_left[1] == 'W_PAWN':
			return true
			
	if len(path_up_right) > 1:
		if path_up_right[1] == 'W_PAWN':
			return true
	
	if len(path_down_left) > 1:
		if path_down_left[1] == 'W_PAWN':
			return true
	
	if len(path_down_right) > 1:
		if path_down_right[1] == 'W_PAWN':
			return true

func white_in_checkmate(column, row):
	var in_check = []
	
	# check the king's position and all squares around it
	in_check.append(white_in_check(column, row))
	if row != 7 and all_pieces[column][row+1] == null:
		in_check.append(white_in_check(column, row+1))
	if row != 0 and all_pieces[column][row-1] == null:
		in_check.append(white_in_check(column, row-1))
	
	if column != 7 and all_pieces[column+1][row] == null:
		in_check.append(white_in_check(column+1, row))
	if (column != 7) and (row != 7) and all_pieces[column+1][row+1] == null:
		in_check.append(white_in_check(column+1, row+1))
	if (column != 7) and (row != 0) and all_pieces[column+1][row-1] == null:
		in_check.append(white_in_check(column+1, row-1))
	
	if (column != 0) and all_pieces[column-1][row] == null:
		in_check.append(white_in_check(column-1, row))
	if (column != 0) and (row != 7) and all_pieces[column-1][row+1] == null:
		in_check.append(white_in_check(column-1, row+1))
	if (column != 0) and (row != 0) and all_pieces[column-1][row-1] == null:
		in_check.append(white_in_check(column-1, row-1))
	
	# check if enemy piece can be killed or blocked
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])
	
	
# Checking if pieces can be killed or blocked
	var i = 0
	# path_up
	if path_up.count(null) != len(path_up):
		if ('B_ROOK' in path_up):
			# can be killed?
			in_check.append(not(black_in_check(column, row + path_up.find('B_ROOK'))))
			i = 1
			# can be blocked?
			while path_up.find('B_ROOK') - i > 0:
				in_check.append(not(white_can_block(column, row + (path_up.find('B_ROOK') - i))))
				i += 1
		if ('B_QUEEN' in path_up):
			in_check.append(not(black_in_check(column, row + path_up.find('B_QUEEN'))))
			i = 1
			while path_up.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column, row + (path_up.find('B_QUEEN') - i))))
				i += 1
	
	# path_down
	if path_down.count(null) != len(path_down):
		if ('B_ROOK' in path_down):
			in_check.append(not(black_in_check(column, row - path_down.find('B_ROOK'))))
			i = 1
			while path_down.find('B_ROOK') - i > 0:
				in_check.append(not(white_can_block(column, row - (path_down.find('B_ROOK') - i))))
				i += 1
		if ('B_QUEEN' in path_up):
			in_check.apppend(not(black_in_check(column, row - path_down.find('B_QUEEN'))))
			i = 1
			while path_up.find('B_QUEEN') - i > 0:
				in_check.apppend(not(white_can_block(column, row - (path_down.find('B_QUEEN') - i))))
				i += 1
	
	# path_left
	if path_left.count(null) != len(path_left):
		if ('B_ROOK' in path_left):
			in_check.append(not(black_in_check(column - path_left.find('B_ROOK'), row)))
			i = 1
			while path_down.find('B_ROOK') - i > 0:
				in_check.append(not(white_can_block(column - (path_left.find('B_ROOK')-1), row)))
				i += 1
		if ('B_QUEEN' in path_left):
			in_check.append(not(black_in_check(column - path_left.find('B_QUEEN'), row)))
			i = 1
			while path_up.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column - (path_left.find('B_QUEEN')-1), row)))
				i += 1
	
	# path_right
	if path_right.count(null) != len(path_right):
		if ('B_ROOK' in path_right):
			in_check.append(not(black_in_check(column + path_right.find('B_ROOK'), row)))
			i = 1
			while path_down.find('B_ROOK') - i > 0:
				in_check.append(not(white_can_block(column + (path_right.find('B_ROOK')-1), row)))
				i += 1
		if ('B_QUEEN' in path_right):
			in_check.append(not(black_in_check(column + path_right.find('B_QUEEN'), row)))
			i = 1
			while path_up.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column + (path_right.find('B_QUEEN')-i), row)))
				i += 1
	
	# path_up_left
	if path_up_left.count(null) != len(path_up_left):
		if ('B_BISHOP' in path_up_left):
			in_check.append(not(black_in_check(column - path_up_left.find('B_BISHOP'), row + path_up_left.find('B_BISHOP'))))
			i = 1
			while path_up_left.find('B_BISHOP') - i >0:
				in_check.append(not(white_can_block(column - (path_up_left.find('B_BISHOP')-i), row + (path_up_left.find('B_BISHOP')-i))))
				i += 1
		if ('B_QUEEN' in path_up_left):
			in_check.append(not(black_in_check(column - path_up_left.find('B_QUEEN'), row + path_up_left.find('B_QUEEN'))))
			i = 1
			while path_up.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column - (path_up_left.find('B_QUEEN')-i), row + (path_up_left.find('B_QUEEN')-i))))
				i += 1
		if path_up_left[1] == 'B_PAWN':
			in_check.append(not(black_in_check(column-1, row+1)))
				
	# path_up_right
	if path_up_right.count(null) != len(path_up_right):
		if ('B_BISHOP' in path_up_right):
			in_check.append(not(black_in_check(column + path_up_right.find('B_BISHOP'), row + path_up_right.find('B_BISHOP'))))
			i = 1
			while path_up_right.find('B_BISHOP') - i >0:
				in_check.append(not(white_can_block(column + (path_up_right.find('B_BISHOP')-i), row + (path_up_right.find('B_BISHOP')-i))))
				i += 1
		if ('B_QUEEN' in path_up_right):
			in_check.append(not(black_in_check(column + path_up_right.find('B_QUEEN'), row + path_up_right.find('B_QUEEN'))))
			i = 1
			while path_up_right.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column + path_up_right.find('B_QUEEN') - i, row + path_up_right.find('B_QUEEN') - i)))
				i += 1
		if path_up_right[1] == 'B_PAWN':
			in_check.append(not(black_in_check(column+1, row+1)))
				
	# path_down_left
	if path_down_left.count(null) != len(path_down_left):
		if ('B_BISHOP' in path_down_left):
			in_check.append(not(black_in_check(column - path_down_left.find('B_BISHOP'), row - path_down_left.find('B_BISHOP'))))
			i = 1
			while path_down_left.find('B_BISHOP') - i >0:
				in_check.append(not(white_can_block(column - (path_down_left.find('B_BISHOP')-i), row - (path_down_left.find('B_BISHOP')-i))))
				i += 1
		if ('B_QUEEN' in path_down_left):
			in_check.append(not(black_in_check(column - path_down_left.find('B_QUEEN'), row - path_down_left.find('B_QUEEN'))))
			i = 1
			while path_down_left.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column - (path_down_left.find('B_QUEEN')-i), row - (path_down_left.find('B_QUEEN')-i))))
				i += 1
		if path_down_left[1] == 'B_PAWN':
			in_check.append(not(black_in_check(column-1, row-1)))
				
	# path_down_right
	if path_down_right.count(null) != len(path_down_right):
		if ('B_BISHOP' in path_down_right):
			in_check.append(not(black_in_check(column + path_down_right.find('B_BISHOP'), row - path_down_right.find('B_BISHOP'))))
			i = 1
			while path_down_right.find('B_BISHOP') - i >0:
				in_check.append(not(white_can_block(column + (path_down_right.find('B_BISHOP')-i), row - (path_down_right.find('B_BISHOP')-i))))
				i += 1
		if ('B_QUEEN' in path_down_right):
			in_check.append(not(black_in_check(column + path_down_right.find('B_QUEEN'), row - path_down_right.find('B_QUEEN'))))
			i = 1
			while path_down_right.find('B_QUEEN') - i > 0:
				in_check.append(not(white_can_block(column + (path_down_right.find('B_QUEEN')-i), row - (path_down_right.find('B_QUEEN')-i))))
				i += 1
		if path_down_right[1] == 'B_PAWN':
			in_check.append(not(black_in_check(column+1, row-1)))
	
	
	# chekmate or not
	if in_check.count(true) == len(in_check):
		return true
	else:
		return false

func black_in_checkmate(column, row):
	var in_check = []
	
	# check the king's position and all squares around it
	in_check.append(black_in_check(column, row))
	if row != 7 and all_pieces[column][row+1] == null:
		in_check.append(black_in_check(column, row+1))
	if row != 0 and all_pieces[column][row-1] == null:
		in_check.append(black_in_check(column, row-1))
	
	if column != 7 and all_pieces[column+1][row] == null:
		in_check.append(black_in_check(column+1, row))
	if (column != 7) and (row != 7) and all_pieces[column+1][row+1] == null:
		in_check.append(black_in_check(column+1, row+1))
	if (column != 7) and (row != 0) and all_pieces[column+1][row-1] == null:
		in_check.append(black_in_check(column+1, row-1))
	
	if (column != 0) and all_pieces[column-1][row] == null:
		in_check.append(black_in_check(column-1, row))
	if (column != 0) and (row != 7) and all_pieces[column-1][row+1] == null:
		in_check.append(black_in_check(column-1, row+1))
	if (column != 0) and (row != 0) and all_pieces[column-1][row-1] == null:
		in_check.append(black_in_check(column-1, row-1))
	
	# check if enemy piece can be killed or blocked
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])

# Checking if pieces can be killed or blocked
	var i = 0
	# path_up
	if path_up.count(null) != len(path_up):
		if ('W_ROOK' in path_up):
			# can be killed?
			in_check.append(not(white_in_check(column, row + path_up.find('W_ROOK'))))
			i = 1
			# can be blocked?
			while path_up.find('W_ROOK') - i > 0:
				in_check.append(not(black_can_block(column, row + (path_up.find('W_ROOK') - i))))
				i += 1
		if ('W_QUEEN' in path_up):
			in_check.append(not(white_in_check(column, row + path_up.find('W_QUEEN'))))
			i = 1
			while path_up.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column, row + (path_up.find('W_QUEEN') - i))))
				i += 1
	
	# path_down
	if path_down.count(null) != len(path_down):
		if ('W_ROOK' in path_down):
			in_check.append(not(white_in_check(column, row - path_down.find('W_ROOK'))))
			i = 1
			while path_down.find('W_ROOK') - i > 0:
				in_check.append(not(black_can_block(column, row - (path_down.find('W_ROOK') - i))))
				i += 1
		if ('W_QUEEN' in path_up):
			in_check.apppend(not(white_in_check(column, row - path_down.find('W_QUEEN'))))
			i = 1
			while path_up.find('W_QUEEN') - i > 0:
				in_check.apppend(not(black_can_block(column, row - (path_down.find('W_QUEEN') - i))))
				i += 1
	
	# path_left
	if path_left.count(null) != len(path_left):
		if ('W_ROOK' in path_left):
			in_check.append(not(white_in_check(column - path_left.find('W_ROOK'), row)))
			i = 1
			while path_down.find('W_ROOK') - i > 0:
				in_check.append(not(black_can_block(column - (path_left.find('W_ROOK')-1), row)))
				i += 1
		if ('W_QUEEN' in path_left):
			in_check.append(not(white_in_check(column - path_left.find('W_QUEEN'), row)))
			i = 1
			while path_up.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column - (path_left.find('W_QUEEN')-1), row)))
				i += 1
	
	# path_right
	if path_right.count(null) != len(path_right):
		if ('W_ROOK' in path_right):
			in_check.append(not(white_in_check(column + path_right.find('W_ROOK'), row)))
			i = 1
			while path_down.find('W_ROOK') - i > 0:
				in_check.append(not(black_can_block(column + (path_right.find('W_ROOK')-1), row)))
				i += 1
		if ('W_QUEEN' in path_right):
			in_check.append(not(white_in_check(column + path_right.find('W_QUEEN'), row)))
			i = 1
			while path_up.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column + (path_right.find('W_QUEEN')-i), row)))
				i += 1
	
	# path_up_left
	if path_up_left.count(null) != len(path_up_left):
		if ('W_BISHOP' in path_up_left):
			in_check.append(not(white_in_check(column - path_up_left.find('W_BISHOP'), row + path_up_left.find('W_BISHOP'))))
			i = 1
			while path_up_left.find('W_BISHOP') - i >0:
				in_check.append(not(black_can_block(column - (path_up_left.find('W_BISHOP')-i), row + (path_up_left.find('W_BISHOP')-i))))
				i += 1
		if ('W_QUEEN' in path_up_left):
			in_check.append(not(white_in_check(column - path_up_left.find('W_QUEEN'), row + path_up_left.find('W_QUEEN'))))
			i = 1
			while path_up.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column - (path_up_left.find('W_QUEEN')-i), row + (path_up_left.find('W_QUEEN')-i))))
				i += 1
		if path_up_left[1] == 'W_PAWN':
			in_check.append(not(white_in_check(column-1, row+1)))
				
	# path_up_right
	if path_up_right.count(null) != len(path_up_right):
		if ('W_BISHOP' in path_up_right):
			in_check.append(not(white_in_check(column + path_up_right.find('W_BISHOP'), row + path_up_right.find('W_BISHOP'))))
			i = 1
			while path_up_right.find('W_BISHOP') - i >0:
				in_check.append(not(black_can_block(column + (path_up_right.find('W_BISHOP')-i), row + (path_up_right.find('W_BISHOP')-i))))
				i += 1
		if ('W_QUEEN' in path_up_right):
			in_check.append(not(white_in_check(column + path_up_right.find('W_QUEEN'), row + path_up_right.find('W_QUEEN'))))
			i = 1
			while path_up_right.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column + path_up_right.find('W_QUEEN') - i, row + path_up_right.find('W_QUEEN') - i)))
				i += 1
		if path_up_right[1] == 'W_PAWN':
			in_check.append(not(white_in_check(column+1, row+1)))
				
	# path_down_left
	if path_down_left.count(null) != len(path_down_left):
		if ('W_BISHOP' in path_down_left):
			in_check.append(not(white_in_check(column - path_down_left.find('W_BISHOP'), row - path_down_left.find('W_BISHOP'))))
			i = 1
			while path_down_left.find('W_BISHOP') - i >0:
				in_check.append(not(black_can_block(column - (path_down_left.find('W_BISHOP')-i), row - (path_down_left.find('W_BISHOP')-i))))
				i += 1
		if ('W_QUEEN' in path_down_left):
			in_check.append(not(white_in_check(column - path_down_left.find('W_QUEEN'), row - path_down_left.find('W_QUEEN'))))
			i = 1
			while path_down_left.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column - (path_down_left.find('W_QUEEN')-i), row - (path_down_left.find('W_QUEEN')-i))))
				i += 1
		if path_down_left[1] == 'W_PAWN':
			in_check.append(not(white_in_check(column-1, row-1)))
				
	# path_down_right
	if path_down_right.count(null) != len(path_down_right):
		if ('W_BISHOP' in path_down_right):
			in_check.append(not(white_in_check(column + path_down_right.find('W_BISHOP'), row - path_down_right.find('W_BISHOP'))))
			i = 1
			while path_down_right.find('W_BISHOP') - i >0:
				in_check.append(not(black_can_block(column + (path_down_right.find('W_BISHOP')-i), row - (path_down_right.find('W_BISHOP')-i))))
				i += 1
		if ('W_QUEEN' in path_down_right):
			in_check.append(not(white_in_check(column + path_down_right.find('W_QUEEN'), row - path_down_right.find('W_QUEEN'))))
			i = 1
			while path_down_right.find('W_QUEEN') - i > 0:
				in_check.append(not(black_can_block(column + (path_down_right.find('W_QUEEN')-i), row - (path_down_right.find('W_QUEEN')-i))))
				i += 1
		if path_down_right[1] == 'W_PAWN':
			in_check.append(not(white_in_check(column+1, row-1)))
	
	
	# in checkmate or not
	if in_check.count(true) == len(in_check):
		return true
	else:
		return false

func white_can_block(column, row):
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])
	
	
# checking if black in check
	# checking for rook and queen attacks
	if ('W_ROOK' in path_up) or ('W_ROOK' in path_down) or ('W_ROOK' in path_left) or ('W_ROOK' in path_right) or ('W_QUEEN' in path_up) or ('W_QUEEN' in path_down) or ('W_QUEEN' in path_left) or ('W_QUEEN' in path_right):
		return true
		
	# checkign for bishop and queen
	if ('W_BISHOP' in path_up_left) or ('W_BISHOP' in path_up_right) or ('W_BISHOP' in path_down_left) or ('W_BISHOP' in path_down_right) or ('W_QUEEN' in path_up_left) or ('W_QUEEN' in path_up_right) or ('W_QUEEN' in path_down_left) or ('W_QUEEN' in path_down_right):
		return true
	
	 # checking for knight attacks
	if ('W_KNIGHT' in path_knights):
		return true
	
	# checking for pawn attacks
	if len(path_down) > 1:
		if path_down[1] == 'W_PAWN':
			return true

func black_can_block(column, row):
	# lists
	var path_up = [null]
	var path_down = [null]
	var path_left = [null]
	var path_right = [null]
	var path_up_left = [null]
	var path_up_right = [null]
	var path_down_left = [null]
	var path_down_right = [null]
	var path_knights = [null]
	
	# counters
	var i_up = 0
	var i_down = 0
	var i_left = 0
	var i_right = 0
	var i_up_left = 0
	var i_up_right = 0
	var i_down_left = 0
	var i_down_right = 0
	
	
	# checking up
	while ((path_up[len(path_up)-1] == null) or (path_up[len(path_up)-1] == 'MINE')) and (row+i_up < 7):
		i_up += 1
		path_up.append(piece_types[column][row+i_up])
	
	# checking down
	while ((path_down[len(path_down)-1] == null) or (path_down[len(path_down)-1] == 'MINE')) and (row-i_down > 0):
		i_down += 1
		path_down.append(piece_types[column][row-i_down])
	
	# checking left
	while ((path_left[len(path_left)-1] == null) or (path_left[len(path_left)-1] == 'MINE')) and (column-i_left > 0):
		i_left += 1
		path_left.append(piece_types[column-i_left][row])
		
	# checking right
	while ((path_right[len(path_right)-1] == null) or (path_right[len(path_right)-1] == 'MINE')) and (column+i_right < 7):
		i_right += 1
		path_right.append(piece_types[column+i_right][row])
	
	# checking up_left
	while ((path_up_left[len(path_up_left)-1] == null) or (path_up_left[len(path_up_left)-1] == 'MINE')) and (column-i_up_left > 0) and (row+i_up_left < 7):
		i_up_left += 1
		path_up_left.append(piece_types[column - i_up_left][row + i_up_left])
	
	# checking up_right
	while ((path_up_right[len(path_up_right)-1] == null) or (path_up_right[len(path_up_right)-1] == 'MINE')) and (column+i_up_right < 7) and (row+i_up_right < 7):
		i_up_right += 1
		path_up_right.append(piece_types[column + i_up_right][row + i_up_right])
	
	# checking down_left
	while ((path_down_left[len(path_down_left)-1] == null) or (path_down_left[len(path_down_left)-1] == 'MINE')) and (column-i_down_left > 0) and (row-i_down_left > 0):
		i_down_left += 1
		path_down_left.append(piece_types[column - i_down_left][row - i_down_left])
	
	# checking down_right
	while ((path_down_right[len(path_down_right)-1] == null) or (path_down_right[len(path_down_right)-1] == 'MINE')) and (column+i_down_right < 7) and (row-i_down_right > 0):
		i_down_right += 1
		path_down_right.append(piece_types[column + i_down_right][row - i_down_right])
	
	# checking knight paths
	if (column+2 <= 7):
		if (row+1 <= 7):
			path_knights.append(piece_types[column+2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column+2][row-1])
	if (column-2 >= 0):
		if (row+1 <= 7):
			path_knights.append(piece_types[column-2][row+1])
		if (row-1 >= 0):
			path_knights.append(piece_types[column-2][row-1])
	if (row+2 <= 7):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row+2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row+2])
	if (row-2 >= 0):
		if (column+1 <= 7):
			path_knights.append(piece_types[column+1][row-2])
		if (column-1 >= 0):
			path_knights.append(piece_types[column-1][row-2])
	
	# checking if white in check
	# checking for rook and queen attacks
	if ('B_ROOK' in path_up) or ('B_ROOK' in path_down) or ('B_ROOK' in path_left) or ('B_ROOK' in path_right) or ('B_QUEEN' in path_up) or ('B_QUEEN' in path_down) or ('B_QUEEN' in path_left) or ('B_QUEEN' in path_right):
		return true
		
	# checkign for bishop and queen
	if ('B_BISHOP' in path_up_left) or ('B_BISHOP' in path_up_right) or ('B_BISHOP' in path_down_left) or ('B_BISHOP' in path_down_right) or ('B_QUEEN' in path_up_left) or ('B_QUEEN' in path_up_right) or ('B_QUEEN' in path_down_left) or ('B_QUEEN' in path_down_right):
		return true
	
	 # checking for knight attacks
	if ('B_KNIGHT' in path_knights):
		return true
	
	# checking for pawn attacks
	if len(path_up) > 1:
		if path_up[1] == 'B_PAWN':
			return true



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

