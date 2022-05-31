extends Control

func _on_NewGameTest_pressed():
	pass

func _on_NewGameSean_pressed():
	pass

func _on_Settings_pressed():
	var settings_menu = load("res://src/scenes/menus/SettingsMenu.tscn").instance()
	get_parent().add_child(settings_menu)
