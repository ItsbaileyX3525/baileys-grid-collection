extends Control


func _on_tactactoe_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Games/noughtsandcrosses.tscn")

func _on_merge_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Games/merge_city.tscn")

func _on__pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Games/2048.tscn")
