extends Node

const game_path = "user://gameData.json"

var game_data: Dictionary = {
	"2048": {
		"highest_block" : 0,
		"high_score" : 0,
	},
	"tictactoe": {
		
	},
	"mergecity": {
		"row1" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "burger",
			"5" : "burger",
			"6" : "burger",
			"7" : "burger",
			"8" : "burger",
			"9" : "burger"
		},
		"row2" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "burger",
			"5" : "burger",
			"6" : "burger",
			"7" : "burger",
			"8" : "burger",
			"9" : "burger"
		},
		"row3" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "burger",
			"5" : "burger",
			"6" : "burger",
			"7" : "burger",
			"8" : "burger",
			"9" : "burger"
		},
		"row4" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "burger",
			"5" : "burger",
			"6" : "burger",
			"7" : "burger",
			"8" : "burger",
			"9" : "burger"
		},
		"row5" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "burger",
			"5" : "burger",
			"6" : "burger",
			"7" : "burger",
			"8" : "burger",
			"9" : "burger"
		},
		
	}
}

func save_data() -> void:
	var file = FileAccess.open(game_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(game_data))
	file.close()

func load_data():
	if not FileAccess.file_exists(game_path):
		save_data()
		return
	
	var file = FileAccess.open(game_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	if typeof(data) == TYPE_DICTIONARY:
		game_data = data
	
func _ready() -> void:
	load_data()
