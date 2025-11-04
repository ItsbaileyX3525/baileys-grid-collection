extends Control

@onready var settings_applied_anim: AnimationPlayer = $SettingsApplied/AnimationPlayer
@onready var vol: Label = $VBoxContainer/Volume/Vol


func _on_save_pressed() -> void:
	settings_applied_anim.play("play")


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_h_slider_value_changed(value: float) -> void:
	var audio_bus = AudioServer.get_bus_index("Master")
	vol.text = str(int(value))
	AudioServer.set_bus_volume_linear(
		audio_bus,
		value/10
	)

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
