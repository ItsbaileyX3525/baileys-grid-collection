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
		"coins" : 0,
		"min_purchase" : "burger",
		"purchase_price" : 10,
		"purchases_till_upgrade" : 20,
		"purchases_till_price" : 4,
		"row1" : {
			"1" : "burger",
			"2" : "burger",
			"3" : "burger",
			"4" : "none",
			"5" : "none",
			"6" : "none",
			"7" : "none",
			"8" : "none",
			"9" : "none"
		},
		"row2" : {
			"1" : "none",
			"2" : "none",
			"3" : "none",
			"4" : "none",
			"5" : "none",
			"6" : "none",
			"7" : "none",
			"8" : "none",
			"9" : "none"
		},
		"row3" : {
			"1" : "none",
			"2" : "none",
			"3" : "none",
			"4" : "none",
			"5" : "none",
			"6" : "none",
			"7" : "none",
			"8" : "none",
			"9" : "none"
		},
		"row4" : {
			"1" : "none",
			"2" : "none",
			"3" : "none",
			"4" : "none",
			"5" : "none",
			"6" : "none",
			"7" : "none",
			"8" : "none",
			"9" : "none"
		},
		"row5" : {
			"1" : "none",
			"2" : "none",
			"3" : "none",
			"4" : "none",
			"5" : "none",
			"6" : "none",
			"7" : "none",
			"8" : "none",
			"9" : "none"
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
