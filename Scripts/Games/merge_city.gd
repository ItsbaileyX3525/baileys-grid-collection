extends Control
@onready var button_container: VBoxContainer = $GameArea/VBoxContainer

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
		if prev_item == curr_item: #Merge
			previous_selected.get_child(0).set_meta("item", "none")
			previous_selected.get_child(0).texture = null
			currently_selected.get_child(0).set_meta("item", upgrade_path[curr_item])
			currently_selected.get_child(0).texture = items[upgrade_path[curr_item]]
		elif curr_item == "none": #Empty space, move it
			previous_selected.get_child(0).texture = null
			previous_selected.get_child(0).set_meta("item", "none")
			currently_selected.get_child(0).texture = items[prev_item]
			currently_selected.get_child(0).set_meta("item", prev_item)
		on_click = 0
		previous_selected = null
		currently_selected = null
	elif on_click == 3:
		previous_selected = null
		currently_selected = button
		on_click = 1

func _ready() -> void:
	var children = button_container.get_children()
	for e in children:
		var grandchildren = e.get_children()
		for i in grandchildren:
			if i is Button:
				i.pressed.connect(func(): handle_click(i))
				if i.get_child(0).texture == null:
					i.get_child(0).set_meta("item", "none")

func _on_delete_pressed() -> void:
	if currently_selected:
		currently_selected.get_child(0).texture = null
		currently_selected.get_child(0).set_meta("item", "none")
		currently_selected = null
		on_click = 0

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")
