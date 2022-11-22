extends Control

onready var scene_handler = get_node("/root/SceneHandler")
onready var game_scene = scene_handler.game_scene
onready var label_text = $PanelContainer/VBoxContainer/Label.text

func _on_RestartButton_pressed():
	scene_handler.restart_level()

func _on_MainMenuButton_pressed():
	if get_tree().reload_current_scene() != OK:
		print("error reload scene")
