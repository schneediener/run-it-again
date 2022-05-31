extends Node
var current_level

var game_scene
var main_menu

func _ready():
	load_main_menu()
	
	if get_node("MainMenu/Margin/VBoxContainer/NewGameSean").connect("pressed", self, "_on_NewGameSean_pressed") != OK:
		print("Signal connect for _on_NewGameSean_pressed failed")
	else:
		print ("NewGameSean connected")
	if get_node("MainMenu/Margin/VBoxContainer/NewGameTest").connect("pressed", self, "_on_NewGameTest_pressed") != OK:
		print("Signal connect for _on_NewGameTest_pressed failed")
	else:
		print ("NewGameTest connected")
	if get_node("MainMenu/Margin/VBoxContainer/SaveAndQuit").connect("pressed", self, "_on_SaveAndQuit_pressed") != OK:
		print("Signal connect for _on_SaveAndQuit_pressed failed")
	else:
		print ("SaveAndQuit connected")
	randomize()
	
func _process(_delta):
	if Input.is_action_pressed("ig_restart_level"):
		if get_tree().reload_current_scene() != OK:
			push_error("backspace restart failed")
func _on_NewGameSean_pressed():
#	self.queue_free()
#	get_tree().change_scene("res://src/scenes/levels/SeanMap.tscn")
	if main_menu and is_instance_valid(main_menu):
		main_menu.queue_free()
		main_menu = null
	game_scene = load("res://src/scenes/GameScene.tscn").instance()
	game_scene.map_node = "map_1"
	current_level = "map_1"
	add_child(game_scene)
	
#	game_scene.add_child(sean_game)
func _on_NewGameTest_pressed():
	if is_instance_valid($MainMenu):
		$MainMenu.queue_free()
		main_menu = null
	game_scene = load("res://src/scenes/GameScene.tscn").instance()
	game_scene.map_node = "map_2"
	current_level = "map_2"
	add_child(game_scene)
	
func _on_SaveAndQuit_pressed():
	get_tree().quit()
func load_main_menu():
	if game_scene and is_instance_valid(game_scene):
		game_scene.free()
		game_scene = null
	main_menu = load("res://src/scenes/menus/MainMenu.tscn").instance()
	add_child(main_menu)
func restart_level():
	if game_scene and is_instance_valid(game_scene):
		game_scene.queue_free()
		game_scene = null
		
		if !game_scene:
			match current_level:
				"map_1":
					_on_NewGameSean_pressed()
				"map_2":
					_on_NewGameTest_pressed()
	
