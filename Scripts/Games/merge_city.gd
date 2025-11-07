extends Control
@onready var button_container: VBoxContainer = $GameArea/VBoxContainer
@onready var coins_label: Label = $Toolbar/HBoxContainer/CoinsLabel
@onready var price_label: Label = $Toolbar/HBoxContainer/Price

var texture_rects: Array = [] #Can use this for general look up, no expensive loops

var currently_selected: Button
var previous_selected: Button
var on_click: int = 0
var coins: int = 50
var purchase_price: int = 10
var min_purchase: String = "burger"
var purchases_till_price: int = 6
var purchases_till_upgrade: int = 7

var purchase_path: Dictionary = {
	"burger" : [
		"burger", "chicken", "gibiASMR"
	],
	"chicken" : [
		"chicken", "gibiASMR", "som"
	],
	"gibiASMR" : [
		"gibiASMR", "som", "elltommo" 
	],
	"som" : [
		"som" , "elltommo", "projector"
	],
	"elltommo" : [
		"elltommo", "projector", "vue"
	],
	"projector" : [
		"projector", "vue", "skibidi"
	],
	"vue" : [
		"vue", "skibidi", "luffy"
	],
	"skibidi" : [
		"skibidi", "luffy", "mining"
	]
}

var highest_purchase: String = "skibidi"

var items: Dictionary = {
	"burger" : preload("uid://l50p1x3khroq"),
	"chicken" : preload("uid://dmoj2n6wk22mp"),
	"gibiASMR" : preload("uid://cbsdbmua04fiq"),
	"som" : preload("uid://br2kxpdue76xv"),
	"elltommo" : preload("uid://cnhwuapu13gb7"),
	"projector" : preload("uid://duexs1hykb3g8"),
	"vue" : preload("uid://bsxsemlfqqci5"),
	"skibidi" : preload("uid://k4eesinfocef"),
	"luffy" : preload("uid://dlloa4p14qxuy"),
	"mining" : preload("uid://dxl2pnd0i2ypr"),
}

var income: Dictionary = {
	"none" : 0,
	"burger" : 1,
	"chicken" : 3,
	"gibiASMR" : 7,
	"som" : 15,
	"elltommo" : 31,
	"projector" : 63,
	"vue" : 127,
	"skibidi" : 255,
	"luffy" : 511,
	"mining" : 1023
}

var upgrade_path: Dictionary = { #Current item : item if upgraded
	"burger" : "chicken",
	"chicken" : "gibiASMR",
	"gibiASMR" : "som",
	"som" : "elltommo",
	"elltommo" : "projector",
	"projector" : "vue",
	"vue" : "skibidi",
	"skibidi" : "luffy",
	"luffy" : "mining",
}

#Chazza written command
func format_number(num: int) -> String:
	var suffixes = ["", "k", "m", "b", "t", "q", "Q"]
	var index = 0
	var value = float(num)

	while value >= 1000.0 and index < suffixes.size() - 1:
		value /= 1000.0
		index += 1

	var rounded = round(value * 10) / 10.0
	var text = str(rounded)

	if text.ends_with(".0"):
		text = text.substr(0, text.length() - 2)

	return text + suffixes[index]


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
			texture_rects.append(child)

	coins = int(SaveManager.game_data["mergecity"]["coins"])
	min_purchase = SaveManager.game_data["mergecity"]["min_purchase"]
	purchase_price = int(SaveManager.game_data["mergecity"]["purchase_price"])
	purchases_till_upgrade = int(SaveManager.game_data["mergecity"]["purchases_till_upgrade"])
	purchases_till_price = int(SaveManager.game_data["mergecity"]["purchases_till_price"])
	update_game()

func update_game() -> void:
	coins_label.text = "COINS: %s" % format_number(coins)
	price_label.text = "COST: %s" % format_number(purchase_price)

func _on_delete_pressed() -> void:
	if currently_selected:
		currently_selected.get_child(0).texture = null
		currently_selected.get_child(0).set_meta("item", "none")
		var row_index = currently_selected.get_meta("row")
		var item_index = currently_selected.get_meta("item")
		SaveManager.game_data["mergecity"][row_index][item_index] = currently_selected.get_child(0).get_meta("item")
		currently_selected = null
		on_click = 0

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")

func _on_purchase_pressed() -> void:
	if not (coins >= purchase_price):
		return

	coins -= purchase_price
	purchases_till_price -= 1
	purchases_till_upgrade -= 1
	
	if purchases_till_upgrade == 0:
		min_purchase = upgrade_path[min_purchase]
		purchases_till_upgrade = 20
		
	if purchases_till_price == 0:
		purchase_price += int(10 + int((float(purchase_price) / 2)) * 1.1)
		purchases_till_price = 4
	
	var rng = 1
	var purchased: String
	if rng <= 6: #60% chance it's normal
		print(min_purchase)
		print(highest_purchase)
		if purchase_path.has(min_purchase):
			print("has min")
			purchased = purchase_path[min_purchase][0]
		else:
			print("no min, using max")
			purchased = purchase_path[highest_purchase][0]
	elif rng > 6 and rng <= 9: #30% chance next tier
		if purchase_path.has(min_purchase):
			purchased = purchase_path[min_purchase][1]
		else:
			purchased = purchase_path[highest_purchase][1]
	elif rng == 10: #10% rare
		if purchase_path.has(min_purchase):
			purchased = purchase_path[min_purchase][2]
		else:
			purchased = purchase_path[highest_purchase][2]

	var children = button_container.get_children()
	var found_free: bool = false
	for e in children:
		if found_free:
			break
		var grandchildren = e.get_children()
		for i in grandchildren:
			if not (i is Button):
				continue

			var item_meta = i.get_child(0).get_meta("item")
			if item_meta == "none":
				i.get_child(0).set_meta("item", purchased)
				i.get_child(0).texture = items[purchased]

				var row_index = i.get_meta("row")
				var item_index = i.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = purchased
				found_free = true
				break

	SaveManager.game_data["mergecity"]["coins"] = coins
	SaveManager.game_data["mergecity"]["min_purchase"] = min_purchase
	SaveManager.game_data["mergecity"]["purchase_price"] = purchase_price
	SaveManager.game_data["mergecity"]["purchases_till_upgrade"] = purchases_till_upgrade
	SaveManager.game_data["mergecity"]["purchases_till_price"] = purchases_till_price

	SaveManager.save_data()

	update_game()

func _on_earn_timeout() -> void:
	var earn: int = 0
	for e in texture_rects:
		earn += income[e.get_meta("item")]
	coins += earn
	update_game()

func _on_random_spawn_timeout() -> void:
	var rng = 1
	var purchased: String
	if rng <= 6: #60% chance it's normal
		print(min_purchase)
		print(highest_purchase)
		if purchase_path.has(min_purchase):
			print("has min")
			purchased = purchase_path[min_purchase][0]
		else:
			print("no min, using max")
			purchased = purchase_path[highest_purchase][0]
	elif rng > 6 and rng <= 9: #30% chance next tier
		if purchase_path.has(min_purchase):
			purchased = purchase_path[min_purchase][1]
		else:
			purchased = purchase_path[highest_purchase][1]
	elif rng == 10: #10% rare
		if purchase_path.has(min_purchase):
			purchased = purchase_path[min_purchase][2]
		else:
			purchased = purchase_path[highest_purchase][2]

	var children = button_container.get_children()
	var found_free: bool = false
	for e in children:
		if found_free:
			break
		var grandchildren = e.get_children()
		for i in grandchildren:
			if not (i is Button):
				continue

			var item_meta = i.get_child(0).get_meta("item")
			if item_meta == "none":
				i.get_child(0).set_meta("item", purchased)
				i.get_child(0).texture = items[purchased]

				var row_index = i.get_meta("row")
				var item_index = i.get_meta("item")
				SaveManager.game_data["mergecity"][row_index][item_index] = purchased
				found_free = true
				break
