extends Node2D

var map_node

var build_mode = false
#var sell_mode = false
var build_valid = false
var build_location = null
var build_type
var build_tile
var build_tower
var build_scene
var current_health = 30 #setget update_current_health
var current_gold = 500 setget current_gold_set, current_gold_get
var tower_script = load("res://src/scripts/TowersGeneral.gd")
var selected_tower 
var SELECTSHADER = load("res://new_shader.tres")
var shader = ShaderMaterial.new()

func _ready():
	prepare_shader()
	current_gold_set(current_gold)
	
	$UserInterface/HealthBar.value = current_health
	map_node = get_node("SeanMap")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
			i.connect("pressed", self, "initiate_build_mode", [i.related_tower])
			i.connect("pressed", self, "initiate_build_mode", [i.related_tower])
	
	get_node("SeanMap/ExitPoint/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")


func current_gold_set(value):
#	print(value)
	current_gold = value
	$UserInterface/GoldCounter.text = "$" + str(current_gold)

func current_gold_get():
	return current_gold

func prepare_shader():
	shader.set_shader(SELECTSHADER)
	shader.set_shader_param("intensity", 1)
	shader.set_shader_param("sizex", 1000)
	shader.set_shader_param("sizey", 1000)
	shader.set_shader_param("outline_color", Color(255,255,0))

func _on_DamageZone_body_entered(body):
#	print("enemy left map!")
#	print(body.type)
	
	if body.type == "enemy":
		take_damage()
		body.queue_free()

#func update_current_health(new_health):
#	current_health = new_health
#	$UserInterface/HealthBar.value = current_health



func take_damage():
	current_health = current_health-1
	$UserInterface/HealthBar.value = current_health
#	print(current_health)
	#print("hello", current_health, $UserInterface/HealthBar.value)
	if current_health <= 0:
		game_over()

func game_over():
	OS.alert('Game Over - Also make Sean change me to a nicer message in-game!', 'Error')
	get_tree().quit()

func _process(_delta):
	if build_mode:
		update_tower_preview()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if selected_tower:
			selected_tower.get_node("ButtonContainer").visible = false
			selected_tower.get_node("TurretBase").set_material(null)
			selected_tower.get_node("FacingDirection/TurretSprite").set_material(null)
			selected_tower = null
		if build_mode:
			cancel_build_mode()
		
	if event.is_action_pressed("ui_accept"):
		if selected_tower:
			selected_tower.get_node("ButtonContainer").visible = false
			selected_tower.get_node("TurretBase").set_material(null)
			selected_tower.get_node("FacingDirection/TurretSprite").set_material(null)
			selected_tower = null
		if build_mode:
			verify_and_build()
		
		get_tree().set_input_as_handled()



func initiate_build_mode(tower):
	if build_mode:
		cancel_build_mode()
	if selected_tower:
		selected_tower.get_node("ButtonContainer").visible = false
		selected_tower.get_node("TurretBase").set_material(null)
		selected_tower.get_node("FacingDirection/TurretSprite").set_material(null)
		selected_tower = null
	
	build_type = tower.get_name()
	build_scene = tower
	build_tower = tower.instance()
	build_mode = true
	get_node("UserInterface").set_tower_preview(build_tower, get_global_mouse_position())



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
#	print("build mode false")
	get_node("UserInterface/TowerPreview").free()


func verify_and_build():
	var tower_cost
	
	tower_cost = build_tower.buy_value

	if build_valid and current_gold >= tower_cost:
		var new_tower = build_scene.instance()
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


func select_tower(tower_instance):
#	print("Select tower was run")
	var new_tower = tower_instance
	var child_count = tower_instance.get_parent().get_child_count()
	var tower_parent
	
	tower_parent = tower_instance.get_parent()
	tower_parent.remove_child(tower_instance)
	tower_parent.add_child(tower_instance, true)
	
	

	
	tower_instance.get_node("TurretBase").set_material(shader)
	tower_instance.get_node("FacingDirection/TurretSprite").set_material(shader)
	
	if selected_tower:
		var old_tower = selected_tower
		old_tower.get_node("TurretBase").set_material(null)
		old_tower.get_node("FacingDirection/TurretSprite").set_material(null)
		old_tower.get_node("ButtonContainer").visible = false
		
		new_tower.get_node("ButtonContainer").visible = true
		
		
		if new_tower.upgrade_value == null:
			new_tower.get_node("ButtonContainer/Upgrade").visible = false
		
		selected_tower = new_tower
		return
	else:
		selected_tower = new_tower
		selected_tower.get_node("ButtonContainer").visible = true
		selected_tower.get_node("TurretBase").set_material(shader)
		selected_tower.get_node("FacingDirection/TurretSprite").set_material(shader)
		if selected_tower.upgrade_value == null:
			selected_tower.get_node("ButtonContainer/Upgrade").visible = false
	

	
func get_selected_tower():
	return(selected_tower)
