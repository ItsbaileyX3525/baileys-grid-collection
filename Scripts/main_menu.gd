extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/games_selector.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
