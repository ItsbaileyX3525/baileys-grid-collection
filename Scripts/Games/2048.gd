extends Control
@onready var row_1_col_1: Panel = $GameArea/VBoxContainer/MarginContainer1/HBoxContainer/Row1Col1
@onready var row_1_col_2: Panel = $GameArea/VBoxContainer/MarginContainer1/HBoxContainer/Row1Col2
@onready var row_1_col_3: Panel = $GameArea/VBoxContainer/MarginContainer1/HBoxContainer/Row1Col3
@onready var row_1_col_4: Panel = $GameArea/VBoxContainer/MarginContainer1/HBoxContainer/Row1Col4
@onready var row_2_col_1: Panel = $GameArea/VBoxContainer/MarginContainer2/HBoxContainer/Row2Col1
@onready var row_2_col_2: Panel = $GameArea/VBoxContainer/MarginContainer2/HBoxContainer/Row2Col2
@onready var row_2_col_3: Panel = $GameArea/VBoxContainer/MarginContainer2/HBoxContainer/Row2Col3
@onready var row_2_col_4: Panel = $GameArea/VBoxContainer/MarginContainer2/HBoxContainer/Row2Col4
@onready var row_3_col_1: Panel = $GameArea/VBoxContainer/MarginContainer3/HBoxContainer/Row3Col1
@onready var row_3_col_2: Panel = $GameArea/VBoxContainer/MarginContainer3/HBoxContainer/Row3Col2
@onready var row_3_col_3: Panel = $GameArea/VBoxContainer/MarginContainer3/HBoxContainer/Row3Col3
@onready var row_3_col_4: Panel = $GameArea/VBoxContainer/MarginContainer3/HBoxContainer/Row3Col4
@onready var row_4_col_1: Panel = $GameArea/VBoxContainer/MarginContainer4/HBoxContainer/Row4Col1
@onready var row_4_col_2: Panel = $GameArea/VBoxContainer/MarginContainer4/HBoxContainer/Row4Col2
@onready var row_4_col_3: Panel = $GameArea/VBoxContainer/MarginContainer4/HBoxContainer/Row4Col3
@onready var row_4_col_4: Panel = $GameArea/VBoxContainer/MarginContainer4/HBoxContainer/Row4Col4

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

func get_empty_cells() -> Array:
	var empty = []
	for i in range(1,5):
		for e in range(1,5):
			if data["row%d" % e]["col%d" % i] == 0:
				empty.append(Vector2(i, e))
	return empty

func spawn_tile() -> void:
	var empty = get_empty_cells()
	if empty.size() == 0:
		return #Game end logic here?
	var cell = empty[randi() % empty.size()]
	data["row%d" % int(cell.x)]["col%d" % int(cell.y)] = 4 if randi() % 10 == 0 else 2

func update_board() -> void:
	for i in range(1,5):
		for e in range(1,5):
			var input_string: String = "GameArea/VBoxContainer/MarginContainer%d/HBoxContainer/Row%dCol%d" % [i, i, e]
			var panel: Panel = get_node(input_string)
			var value = data["row%d" % i]["col%d" % e]
			var label: Label = panel.get_child(0)
			label.text = str(value if value != 0 else "")
			
func _ready() -> void:
	spawn_tile()
	spawn_tile()
	update_board()

func move_items(dir: String) -> void:
	match dir:
		"up":
			print("Moving up")
		"down":
			print("Moving down")
		"left":
			print("Moving left")
		"right":
			print("Moving right")

func _physics_process(_delta: float) -> void:
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
