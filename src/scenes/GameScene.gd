extends Node2D

var map_node

var build_mode = false
var build_valid = false
var build_location = null
var build_type
var build_tile

func _ready():
	map_node = get_node("SeanMap")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
			i.connect("pressed", self, "initiate_build_mode", [i.get_name()])


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
	build_type = tower_type
	build_mode = true
	get_node("UserInterface").set_tower_preview(build_type, get_global_mouse_position())



func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("TowerExclusion")
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
	if build_valid:
		var new_tower = load("res://src/scenes/towers/" + build_type + "T1.tscn").instance()
		new_tower.position = build_location
		map_node.get_node("Towers").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 9)
		cancel_build_mode()
	else:
		OS.alert('Invalid build location - Also make Sean change me to a nicer message in-game!', 'Error')
