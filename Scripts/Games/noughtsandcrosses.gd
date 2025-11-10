extends Control

@onready var top_left: Button = $GameArea/Borders/TopLeft
@onready var top_middle: Button = $GameArea/Borders/TopMiddle
@onready var top_right: Button = $GameArea/Borders/TopRight
@onready var middle_left: Button = $GameArea/Borders/MiddleLeft
@onready var middle_middle: Button = $GameArea/Borders/MiddleMiddle
@onready var middle_right: Button = $GameArea/Borders/MiddleRight
@onready var bottom_left: Button = $GameArea/Borders/BottomLeft
@onready var bottom_middle: Button = $GameArea/Borders/BottomMiddle
@onready var bottom_right: Button = $GameArea/Borders/BottomRight
@onready var winner_text: Label = $WinLossScreen/Winner
@onready var win_loss_screen: Control = $WinLossScreen

var board: Array = [
	"", "", "",
	"", "", "",
	"", "", ""
]

# Converts a row/col pair into a 1D index
func index(row: int, col: int) -> int:
	return row * 3 + col

func check_match() -> String:
	# Rows
	for row in range(3):
		var i = index(row, 0)
		if board[i] != "" and board[i] == board[i + 1] and board[i + 1] == board[i + 2]:
			return board[i]

	# Columns
	for col in range(3):
		if board[col] != "" and board[col] == board[col + 3] and board[col + 3] == board[col + 6]:
			return board[col]

	# Diagonals
	if board[0] != "" and board[0] == board[4] and board[4] == board[8]:
		return board[0]
	if board[2] != "" and board[2] == board[4] and board[4] == board[6]:
		return board[2]

	return "" # No winner yet

func bot_move(bot_symbol: String, player_symbol: String) -> void:
	for i in range(9):
		if board[i] == "":
			board[i] = bot_symbol
			if check_match() == bot_symbol:
				make_move(i, bot_symbol)
				return
			board[i] = ""

	for i in range(9):
		if board[i] == "":
			board[i] = player_symbol
			if check_match() == player_symbol:
				board[i] = bot_symbol
				make_move(i, bot_symbol)
				return
			board[i] = ""

	if board[4] == "":
		make_move(4, bot_symbol)
		return

	for i in [0, 2, 6, 8]:
		if board[i] == "":
			make_move(i, bot_symbol)
			return

	for i in range(9):
		if board[i] == "":
			make_move(i, bot_symbol)
			return

func make_move(index: int, symbol: String) -> void:
	board[index] = symbol
	match index:
		0: top_left.text = symbol
		1: top_middle.text = symbol
		2: top_right.text = symbol
		3: middle_left.text = symbol
		4: middle_middle.text = symbol
		5: middle_right.text = symbol
		6: bottom_left.text = symbol
		7: bottom_middle.text = symbol
		8: bottom_right.text = symbol

func _on_top_left_pressed(): player_move(0, top_left)
func _on_top_middle_pressed(): player_move(1, top_middle)
func _on_top_right_pressed(): player_move(2, top_right)
func _on_middle_left_pressed(): player_move(3, middle_left)
func _on_middle_middle_pressed(): player_move(4, middle_middle)
func _on_middle_right_pressed(): player_move(5, middle_right)
func _on_bottom_left_pressed(): player_move(6, bottom_left)
func _on_bottom_middle_pressed(): player_move(7, bottom_middle)
func _on_bottom_right_pressed(): player_move(8, bottom_right)

func player_move(index: int, button: Button) -> void:
	if board[index] == "":
		board[index] = "O"
		button.text = "O"
		var winner = check_match()
		if winner != "":
			win_loss_screen.visible = true
			winner_text.text = "Winner: " + winner
			return
		bot_move("X", "O")
		winner = check_match()
		if winner != "":
			win_loss_screen.visible = true
			winner_text.text = "Winner: " + winner

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Games/noughtsandcrosses.tscn")

func _on_leave_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")
