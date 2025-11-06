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
	pass
