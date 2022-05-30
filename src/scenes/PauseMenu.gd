extends Control

onready var game_scene = get_node("/root/SceneHandler/GameScene")


func _on_ResumeButton_pressed():
	get_tree().paused = false
	game_scene.esc_pause = false
	self.queue_free()


func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_SettingsButton_pressed():
#	var settings_menu# = load().instance()
#
#	self.hide()
	pass


func _on_SoundSlider_value_changed(value):
	pass # Replace with function body.


func _on_MusicSlider_value_changed(value):
	pass # Replace with function body.


func _on_MainMenuButton_pressed():
#	game_scene.queue_free()
#	var main_menu = load("res://src/scenes/menus/MainMenu.tscn").instance()
#	get_node("/root/SceneHandler").add_child(main_menu)
	get_tree().paused = false
	get_tree().set_current_scene(game_scene)
	var curr_scene = get_tree().get_current_scene()
	get_tree().reload_current_scene()


func _on_ExitButton_pressed():
	get_tree().quit()
