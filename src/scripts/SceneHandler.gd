extends Node

func _ready():
	if get_node("MainMenu/Margin/VBoxContainer/NewGameSean").connect("pressed", self, "_on_NewGameSean_pressed") != OK:
		print("Signal connect for _on_NewGameSean_pressed failed")
	if get_node("MainMenu/Margin/VBoxContainer/NewGameTest").connect("pressed", self, "_on_NewGameTest_pressed") != OK:
		print("Signal connect for _on_NewGameTest_pressed failed")
	if get_node("MainMenu/Margin/VBoxContainer/SaveAndQuit").connect("pressed", self, "_on_SaveAndQuit_pressed") != OK:
		print("Signal connect for _on_SaveAndQuit_pressed failed")
	randomize()
	

func _on_NewGameSean_pressed():
#	self.queue_free()
#	get_tree().change_scene("res://src/scenes/levels/SeanMap.tscn")
	get_node("MainMenu").queue_free()
	var game_scene = load("res://src/scenes/GameScene.tscn").instance()
	game_scene.map_node = "map_1"
	add_child(game_scene)
	
#	game_scene.add_child(sean_game)
func _on_NewGameTest_pressed():
	get_node("MainMenu").queue_free()
	var game_scene = load("res://src/scenes/GameScene.tscn").instance()
	game_scene.map_node = "map_2"
	add_child(game_scene)
	

func _on_SaveAndQuit_pressed():
	get_tree().quit()
