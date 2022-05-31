extends Control

onready var game_scene = get_node("/root/SceneHandler").game_scene
onready var scene_handler = get_node("/root/SceneHandler")


func _on_ResumeButton_pressed():
	game_scene.remove_pause_menu()


func _on_RestartButton_pressed():
	get_tree().paused = false
	scene_handler.restart_level()


func _on_SettingsButton_pressed():
	var settings_menu = load("res://src/scenes/menus/SettingsMenu.tscn").instance()
	get_parent().add_child(settings_menu)


##ALL READY FOR WHEN SOUND IS ADDED
#func _on_SoundSlider_value_changed(value):
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), value)
#
#func _on_MasterSlider_value_changed(value):
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
#
#func _on_MusicSlider_value_changed(value):
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_MainMenuButton_pressed():
#	game_scene.queue_free()
#	var main_menu = load("res://src/scenes/menus/MainMenu.tscn").instance()
#	get_node("/root/SceneHandler").add_child(main_menu)
	get_tree().paused = false
	get_tree().set_current_scene(game_scene)
	if get_tree().reload_current_scene() != OK:
		print("error reload scene")


func _on_ExitButton_pressed():
	get_tree().quit()
