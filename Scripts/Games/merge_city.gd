extends Control
@onready var button_container: VBoxContainer = $GameArea/VBoxContainer
@onready var coins_label: Label = $Toolbar/HBoxContainer/CoinsLabel

var currently_selected: Button
var previous_selected: Button
var on_click: int = 0

var items: Dictionary = {
	"burger" : preload("uid://l50p1x3khroq"),
	"chicken" : preload("uid://dmoj2n6wk22mp"),
	"gibiASMR" : preload("uid://cbsdbmua04fiq"),
	"som" : preload("uid://br2kxpdue76xv"),
	"elltommo" : preload("uid://cnhwuapu13gb7"),
	"projector" : preload("uid://duexs1hykb3g8"),
}

var upgrade_path: Dictionary = { #Current item : item if upgraded
	"burger" : "chicken",
	"chicken" : "gibiASMR",
	"gibiASMR" : "som",
	"som" : "elltommo",
	"elltommo" : "projector",
}

func handle_click(button: Button) -> void:
	if currently_selected == button: #Disallow self merging.
		currently_selected = null
		previous_selected = null
		on_click = 0
		return
	if on_click == 0:
		currently_selected = button
		on_click += 1
	elif on_click == 1: #Merge if 2 are same
		previous_selected = currently_selected
		currently_selected = button
		on_click += 1
		var curr_item = currently_selected.get_child(0).get_meta("item")
		var prev_item = previous_selected.get_child(0).get_meta("item")
		if prev_item == curr_item and (curr_item != "none" and prev_item != "none"): #Merge
			previous_selected.get_child(0).set_meta("item", "none")
			currently_selected.get_child(0).set_meta("item", upgrade_path[curr_item])
			currently_selected.get_child(0).texture = items[upgrade_path[curr_item]]
			if previous_selected:
				var row_index = previous_selected.get_meta("row")
				var item_index = previous_selected.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = previous_selected.get_child(0).get_meta("item")
			if currently_selected:
				var row_index = currently_selected.get_meta("row")
				var item_index = currently_selected.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = currently_selected.get_child(0).get_meta("item")
			previous_selected.get_child(0).texture = null

		elif curr_item == "none" and prev_item != "none": #Empty space, move it
			previous_selected.get_child(0).set_meta("item", "none")
			currently_selected.get_child(0).texture = items[prev_item]
			currently_selected.get_child(0).set_meta("item", prev_item)
			if previous_selected:
				var row_index = previous_selected.get_meta("row")
				var item_index = previous_selected.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = previous_selected.get_child(0).get_meta("item")
			if currently_selected:
				var row_index = currently_selected.get_meta("row")
				var item_index = currently_selected.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = currently_selected.get_child(0).get_meta("item")
			previous_selected.get_child(0).texture = null
		on_click = 0
		previous_selected = null
		currently_selected = null
	elif on_click == 3:
		previous_selected = null
		currently_selected = button
		on_click = 1

	SaveManager.save_data()

func _ready() -> void:
	var rows = button_container.get_children()
	for row_index in range(rows.size()):
		var row = rows[row_index]
		
		var buttons: Array = []
		for child in row.get_children():
			if child is Button:
				buttons.append(child)
		
		for item_index in range(buttons.size()):
			var btn = buttons[item_index]
			var item_data_key = str(item_index + 1)
			var row_key = "row%d" % (row_index + 1)
			var item_data: String = SaveManager.game_data["mergecity"][row_key].get(item_data_key, "none")
			
			if items.has(item_data):
				btn.get_child(0).texture = items[item_data]
			else:
				btn.icon = null
			btn.expand_icon = true
			btn.get_child(0).set_meta("item", item_data)
			btn.set_meta("row", row_key)
			btn.set_meta("item", item_data_key)
			btn.pressed.connect(func(): handle_click(btn))

			var child = btn.get_child(0)
			if child.has_method("texture") and child.texture == null:
				child.set_meta("item", "none")


func _on_delete_pressed() -> void:
	if currently_selected:
		currently_selected.get_child(0).texture = null
		currently_selected.get_child(0).set_meta("item", "none")
		currently_selected = null
		on_click = 0

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")
