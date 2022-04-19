extends Node2D

var map_node

var build_mode = false
var sell_mode = false
var build_valid = false
var build_location = null
var build_type
var build_tile
var current_health = 30 #setget update_current_health
var current_gold = 500 setget current_gold_set, current_gold_get
var tower_script = load("res://src/scripts/TowersGeneral.gd")

func current_gold_set(value):
	print(value)
	current_gold = value
	$UserInterface/GoldCounter.text = "$" + str(current_gold)

func current_gold_get():
	return current_gold

func _ready():
	current_gold_set(current_gold)
	$UserInterface/HealthBar.value = current_health
	map_node = get_node("SeanMap")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
			i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	
	get_node("SeanMap/ExitPoint/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")
	get_node("SeanMap/ExitPoint/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")

func sell_tower(tower_instance):
	var tower_value
	print("func started" + str(tower_instance))
	
	if sell_mode:
		print("sell mode working")
		build_type = tower_instance.tower_type
		print(build_type)

		if build_type == "GunT1":
			tower_value = 100
		elif build_type == "missile":
			tower_value = 150 #this is all lazy code

		if tower_value:
			var tower_exclusion = map_node.get_node("Navigation2D/TowerExclusion")
			var current_tile = tower_exclusion.world_to_map(get_global_mouse_position())
			print("tower value working")
			current_gold_set(current_gold+tower_value)
			tower_instance.queue_free()
			map_node.get_node("Navigation2D/TowerExclusion").set_cellv(current_tile, -1)
			sell_mode = false
			tower_value = null
		

func _on_DamageZone_body_entered(body):
	if body.get("type"):
		if body.type == "bullet":
			pass
	else:
		take_damage()
		body.queue_free()

#func update_current_health(new_health):
#	current_health = new_health
#	$UserInterface/HealthBar.value = current_health



func take_damage():
	current_health = current_health-1
	$UserInterface/HealthBar.value = current_health
	print(current_health)
	#print("hello", current_health, $UserInterface/HealthBar.value)
	if current_health <= 0:
		game_over()

func game_over():
	OS.alert('Game Over - Also make Sean change me to a nicer message in-game!', 'Error')
	get_tree().quit()

func _process(delta):
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and build_mode:
		cancel_build_mode()
	if event.is_action_pressed("ui_accept") and build_mode:
		verify_and_build()


func initiate_build_mode(tower_type):
	if build_mode == true:
		cancel_build_mode()
	if sell_mode == true:
		sell_mode = false
	build_type = tower_type
	build_mode = true
	get_node("UserInterface").set_tower_preview(build_type, get_global_mouse_position())



func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("Navigation2D/TowerExclusion")
	var current_tile = tower_exclusion.world_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_world(current_tile)
	
	if tower_exclusion.get_cellv(current_tile) == -1:
		get_node("UserInterface").update_tower_preview(tile_position, "ad54ff3c")
		if build_valid != true:
			build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UserInterface").update_tower_preview(tile_position, "adff4545")
		if build_valid:
			build_valid = false


func cancel_build_mode():
	build_mode = false
	get_node("UserInterface/TowerPreview").free()


func verify_and_build():
	var tower_cost
	
	if build_type == "Gun":
		tower_cost = 100
	elif build_type == "Missile":
		tower_cost = 150

	if build_valid and current_gold >= tower_cost:
		var new_tower = load("res://src/scenes/towers/" + build_type + "T1.tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		map_node.get_node("Towers").add_child(new_tower, true)
		map_node.get_node("Navigation2D/TowerExclusion").set_cellv(build_tile, 9)
		#new_tower.connect("input_event", self, "_on_SelectArea_input_event")
		current_gold_set(current_gold-tower_cost)
		
		cancel_build_mode()
	elif build_valid and current_gold < tower_cost:
		OS.alert('NOT ENOUGH MOOLAH')
	else:
		OS.alert('Invalid build location - Also make Sean change me to a nicer message in-game!', 'Error')


func _on_Sell_pressed():
	initiate_sell_mode()
	

func initiate_sell_mode():
	sell_mode = true
	print("Sell Mode:" + str(sell_mode))
