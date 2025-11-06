extends Control
@onready var game_over_panel: Panel = $GameOver
@onready var game_over_text: Label = $GameOver/GameOverText
@onready var score: Label = $GameOver/Score
@onready var highest: Label = $GameOver/Highest
@onready var high_score: Label = $GameOver/HighScore
@onready var highest_score: Label = $GameOver/HighestScore

var game_over: bool = false

var data: Dictionary = {
	"row1" : {
		"col1" : 0,
		"col2" : 0,
		"col3" : 0,
		"col4" : 0
	},
	"row2" : {
		"col1" : 0,
		"col2" : 0,
		"col3" : 0,
		"col4" : 0
	},
	"row3" : {
		"col1" : 0,
		"col2" : 0,
		"col3" : 0,
		"col4" : 0
	},
	"row4" : {
		"col1" : 0,
		"col2" : 0,
		"col3" : 0,
		"col4" : 0
	}
}

func on_death() -> void:
	game_over = true
	var total_score = collect_score()
	var highest_block_match = find_highest()
	var block_highscore = SaveManager.game_data["2048"]["highest_block"]
	var highscore = SaveManager.game_data["2048"]["high_score"]
	if highest_block_match > block_highscore:
		SaveManager.game_data["2048"]["highest_block"] = highest_block_match
	if total_score > highscore:
		SaveManager.game_data["2048"]["high_score"] = total_score
	game_over_panel.visible = true
	score.text = "Score: " + str(total_score)
	highest.text = "Higest block: " + str(highest_block_match)
	highest_score.text = "Block highscore: " + str(block_highscore)
	high_score.text = "Highscore: " + str(highscore)
	SaveManager.save_data()

func get_empty_cells() -> Array:
	var empty = []
	for row_idx in range(1, 5):
		for col_idx in range(1, 5):
			if data["row%d" % row_idx]["col%d" % col_idx] == 0:
				empty.append(Vector2(col_idx, row_idx))
	return empty

func spawn_tile() -> void:
	var empty = get_empty_cells()
	if empty.size() == 0:
		return
	var cell = empty[randi() % empty.size()]
	var row_key = "row%d" % int(cell.y)
	var col_key = "col%d" % int(cell.x)
	
	if data[row_key][col_key] != 0:
		for backup_cell in empty:
			var backup_row = "row%d" % int(backup_cell.y)
			var backup_col = "col%d" % int(backup_cell.x)
			if data[backup_row][backup_col] == 0:
				row_key = backup_row
				col_key = backup_col
				break
	
	data[row_key][col_key] = 4 if randi() % 10 == 0 else 2

func can_move() -> bool:
	for row_idx in range(1, 5):
		for col_idx in range(1, 4):
			var current = data["row%d" % row_idx]["col%d" % col_idx]
			var next = data["row%d" % row_idx]["col%d" % (col_idx + 1)]
			if current == next and current != 0:
				return true
			if current == 0 and next != 0:
				return true
			if current != 0 and next == 0:
				return true
	
	for col_idx in range(1, 5):
		for row_idx in range(1, 4):
			var current = data["row%d" % row_idx]["col%d" % col_idx]
			var next = data["row%d" % (row_idx + 1)]["col%d" % col_idx]
			if current == next and current != 0:
				return true
			if current == 0 and next != 0:
				return true
			if current != 0 and next == 0:
				return true
	
	return false

func update_board() -> void:
	for i in range(1,5):
		for e in range(1,5):
			var input_string: String = "GameArea/VBoxContainer/MarginContainer%d/HBoxContainer/Row%dCol%d" % [i, i, e]
			var panel: Panel = get_node(input_string)
			var value = data["row%d" % i]["col%d" % e]
			var label: Label = panel.get_child(0)
			label.text = str(value if value != 0 else "")

func find_highest() -> int:
	var highest_block: int = 0
	for e in data:
		for z in data[e]:
			for skibidi in data[e][z]:
				if skibidi > highest_block:
					highest_block = int(skibidi)
	return highest_block + 1

func collect_score() -> int:
	var total_score: int = 0
	for e in data:
		for z in data[e]:
			for skibidi in data[e][z]:
				total_score += int(skibidi)
	return total_score

func _ready() -> void:
	spawn_tile()
	spawn_tile()
	update_board()

func compress_line(line: Array) -> Array:
	var compressed = []
	for val in line:
		if val != 0:
			compressed.append(val)
	return compressed

func merge_line(line: Array) -> Array:
	var merged = []
	var i = 0
	while i < line.size():
		if i + 1 < line.size() and line[i] == line[i + 1]:
			merged.append(line[i] * 2)
			i += 2
		else:
			merged.append(line[i])
			i += 1
	return merged

func pad_line(line: Array) -> Array:
	while line.size() < 4:
		line.append(0)
	return line

func process_line(line: Array) -> Array:
	var result = compress_line(line)
	result = merge_line(result)
	result = pad_line(result)
	return result

func move_items(dir: String) -> bool:
	var previous_state = {}
	for row_idx in range(1, 5):
		previous_state["row%d" % row_idx] = {}
		for col_idx in range(1, 5):
			previous_state["row%d" % row_idx]["col%d" % col_idx] = data["row%d" % row_idx]["col%d" % col_idx]
	
	match dir:
		"up":
			for col_idx in range(1, 5):
				var column = []
				for row_idx in range(1, 5):
					column.append(data["row%d" % row_idx]["col%d" % col_idx])
				column = process_line(column)
				var row_positions = [1, 2, 3, 4]
				for idx in range(4):
					data["row%d" % row_positions[idx]]["col%d" % col_idx] = column[idx]
		"down":
			for col_idx in range(1, 5):
				var column = []
				for row_idx in range(4, 0, -1):
					column.append(data["row%d" % row_idx]["col%d" % col_idx])
				column = process_line(column)
				var row_positions = [4, 3, 2, 1]
				for idx in range(4):
					data["row%d" % row_positions[idx]]["col%d" % col_idx] = column[idx]
		"left":
			for row_idx in range(1, 5):
				var row = []
				for col_idx in range(1, 5):
					row.append(data["row%d" % row_idx]["col%d" % col_idx])
				row = process_line(row)
				var col_positions = [1, 2, 3, 4]
				for idx in range(4):
					data["row%d" % row_idx]["col%d" % col_positions[idx]] = row[idx]
		"right":
			for row_idx in range(1, 5):
				var row = []
				for col_idx in range(4, 0, -1):
					row.append(data["row%d" % row_idx]["col%d" % col_idx])
				row = process_line(row)
				var col_positions = [4, 3, 2, 1]
				for idx in range(4):
					data["row%d" % row_idx]["col%d" % col_positions[idx]] = row[idx]
	
	var state_changed = false
	for row_idx in range(1, 5):
		for col_idx in range(1, 5):
			if previous_state["row%d" % row_idx]["col%d" % col_idx] != data["row%d" % row_idx]["col%d" % col_idx]:
				state_changed = true
				break
		if state_changed:
			break
	
	update_board()
	
	if state_changed:
		spawn_tile()
	
	if !can_move():
		on_death()
	
	return state_changed

func _physics_process(_delta: float) -> void:
	if game_over:
		return
	
	if Input.is_action_just_pressed("up"):
		move_items("up")
	
	if Input.is_action_just_pressed("down"):
		move_items("down")
		
	if Input.is_action_just_pressed("left"):
		move_items("left")
	
	if Input.is_action_just_pressed("right"):
		move_items("right")


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Games/2048.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")
