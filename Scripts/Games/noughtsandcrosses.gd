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

var board: Array = [
	"", "", "",
	"", "", "",
	"", "", ""
]

func check_match() -> String:
	for row in board:
		if row[0] != "" and row[0] == row[1] and row[1] == row[2]:
			return row[0]
	
	for col in range(3):
		if board[0][col] != "" and board[0][col] == board[1][col] and board[1][col] == board[2][col]:
			return board[0][col]

	if board[0][0] != "" and board[0][2] == board[1][1] and board[1][1] == board[2][0]:
		return board[0][2]
		
	return "" #Essentially no winner

func _on_top_left_pressed() -> void:
	if board[0] == "":
		board[0] = "o"
		top_left.text = "o"

func _on_top_middle_pressed() -> void:
	if board[1] == "":
		board[1] = "o"
		top_middle.text = "o"

func _on_top_right_pressed() -> void:
	if board[2] == "":
		board[2] = "o"
		top_right.text = "o"

func _on_middle_left_pressed() -> void:
	if board[3] == "":
		board[3] = "o"
		middle_left.text = "o"

func _on_middle_middle_pressed() -> void:
	if board[4] == "":
		board[4] = "o"
		middle_middle.text = "o"

func _on_middle_right_pressed() -> void:
	if board[5] == "":
		board[5] = "o"
		middle_right.text = "o"

func _on_bottom_left_pressed() -> void:
	if board[6] == "":
		board[6] = "o"
		bottom_left.text = "o"

func _on_bottom_middle_pressed() -> void:
	if board[7] == "":
		board[7] = "o"
		bottom_middle.text = "o"

func _on_bottom_right_pressed() -> void:
	if board[8] == "":
		board[8] = "o"
		bottom_right.text = "o"
