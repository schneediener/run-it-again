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
var current_health = 20 #setget update_current_health
var current_gold = 1000 setget current_gold_set, current_gold_get
var tower_script = load("res://src/scripts/TowersGeneral.gd")
var selected_tower 
var SELECTSHADER = load("res://new_shader.tres")
var shader = ShaderMaterial.new()
var current_time = 150

var select_box = null
var selected_array = []

var camera_move_array = [0,0,0,0]

func _ready():
	$Camera2D.position = get_viewport_rect().size / 2
	prepare_shader()
	current_gold_set(current_gold)
	
	$UserInterface/HealthBar.max_value = current_health
	$UserInterface/HealthBar.value = current_health
	$UserInterface/TimeBar.max_value = current_time
	$UserInterface/TimeBar.value = current_time
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
			i.connect("pressed", self, "initiate_build_mode", [i.related_tower])
	
	if map_node == "map_1":
		var temp_map = load("res://src/scenes/levels/SeanMap.tscn").instance()
		add_child(temp_map)
		get_node("SeanMap/ExitPoint/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")
		map_node = temp_map
	elif map_node == "map_2":
		var temp_map = load("res://src/scenes/levels/Map2.tscn").instance()
		add_child(temp_map)
		get_node("Map2/ExitPointLeft/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")
		get_node("Map2/ExitPointRight/DamageZone").connect("body_entered", self, "_on_DamageZone_body_entered")
		map_node = temp_map

func _process(_delta):
	if $UserInterface/TimeBar.value != current_time:
		$UserInterface/TimeBar.value = current_time
	if build_mode:
		run_update_tower_preview()
	
	if get_tree().paused:
		current_time = current_time-0.05
		if current_time <=1:
			start_time()
	
	if Input.is_action_pressed("ui_up"):
		camera_move_array[0] = 1
	else:
		camera_move_array[0] = 0

	if Input.is_action_pressed("ui_down"):
		camera_move_array[1] = 1
	else:
		camera_move_array[1] = 0
		
	if Input.is_action_pressed("ui_left"):
		camera_move_array[2] = 1
	else:
		camera_move_array[2] = 0
	
	if Input.is_action_pressed("ui_right"):
		camera_move_array[3] = 1
	else:
		camera_move_array[3] = 0
	
	move_camera()
	
	if select_box:
		if is_instance_valid(select_box):
			maintain_select_box(get_global_mouse_position())

func move_camera():
	var temp_y = 0
	var temp_x = 0
	
	if camera_move_array[0]==1:
		temp_y -= 10
	if camera_move_array[1]==1:
		temp_y += 10
	if camera_move_array[2]==1:
		temp_x -= 10
	if camera_move_array[3]==1:
		temp_x += 10
	
	$Camera2D.position.y += temp_y
	$Camera2D.position.x += temp_x


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
	get_tree().reload_current_scene()



func stop_time():
	get_tree().paused = true
	$UserInterface/PauseEffect.show()

func start_time():
	get_tree().paused = false
	$UserInterface/PauseEffect.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ig_pause"):
		if get_tree().paused:
			start_time()
		else:
			stop_time()
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
	if event.is_action_pressed("ui_accept"):

		if !select_box:
			create_select_box(get_global_mouse_position())
	if event.is_action_released("ui_accept"):
		if select_box:
			if is_instance_valid(select_box):
				use_select_box()

	if event.is_action_pressed("ig_scroll_up"):
		zoom_camera("up")
	if event.is_action_pressed("ig_scroll_down"):
		zoom_camera("down")


func zoom_camera(direction):
	if direction == "up":
		$Camera2D.zoom -= Vector2(0.1, 0.1)
	elif direction == "down":
		$Camera2D.zoom += Vector2(0.1, 0.1)

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
	set_tower_preview(build_tower, get_global_mouse_position())



func run_update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("Navigation2D/TowerExclusion")
	var current_tile = tower_exclusion.world_to_map(tower_exclusion.to_local(mouse_position))
	var tile_position = tower_exclusion.map_to_world(current_tile)
	var tile = tower_exclusion.get_cellv(current_tile)
	
	if tile == -1:
		update_tower_preview(tile_position, "ad54ff3c")
		if build_valid != true:
			build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		update_tower_preview(tile_position, "adff4545")
		if build_valid:
			build_valid = false

func cancel_build_mode():
	build_mode = false
#	print("build mode false")
	get_node("TowerPreview").free()


func verify_and_build():
	var tower_cost
	
	tower_cost = build_tower.buy_value

	if build_valid and current_gold >= tower_cost:
		var new_tower = build_scene.instance()
		new_tower.position = build_location
		new_tower.built = true
		if new_tower.get("can_shoot"):
			new_tower.can_shoot = true
		map_node.get_node("Towers").add_child(new_tower, true)
		map_node.get_node("Navigation2D/TowerExclusion").set_cellv(build_tile, 9)
		#new_tower.connect("input_event", self, "_on_SelectArea_input_event")
		current_gold_set(current_gold-tower_cost)
		
		cancel_build_mode()
	elif build_valid and current_gold < tower_cost:
		OS.alert('NOT ENOUGH MOOLAH')
	else:
		OS.alert('Invalid build location - Also make Sean change me to a nicer message in-game!', 'Error')

func set_tower_preview(tower_type, mouse_position):
#	print (tower_type)
	
	var drag_tower = tower_type
	
# Method for setting drag_tower by name doesn't feel good, but it's cleaner than my alternative at the moment, see below
#	var drag_tower = null
#	if tower_type == "gun":
#		drag_tower = load("res://src/scenes/towers/GunT1.tscn").instance()
#	else:
#		drag_tower = load("res://src/scenes/towers/MissileT1.tscn").instance()
	if drag_tower.get_node("SelectTower"):
		drag_tower.get_node("SelectTower").visible = false
	
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	if get_node("TowerPreview/DragTower/Range"):
		get_node("TowerPreview/DragTower/Range").visible = true

func update_tower_preview(new_position, color):
	var tower_preview = get_node("TowerPreview")
	var drag_tower = get_node("TowerPreview/DragTower")
	
	tower_preview.rect_position = new_position
	if drag_tower.modulate != Color(color):
		drag_tower.modulate = Color(color)

func select_tower(tower_instance):
#	print("Select tower was run")
	var new_tower = tower_instance
	var child_count = tower_instance.get_parent().get_child_count()
	var tower_parent = new_tower.get_parent()
	
	tower_parent.remove_child(new_tower)
	tower_parent.add_child(new_tower, true)
	
	make_tower_glow(new_tower, "single")
	
	if selected_tower:
		remove_tower_glow(selected_tower)
	
	selected_tower = new_tower


func make_tower_glow(new_tower, select_type):
	new_tower.get_node("TurretBase").set_material(shader)
	new_tower.get_node("FacingDirection/TurretSprite").set_material(shader)
	
	if select_type == "single":
		new_tower.get_node("ButtonContainer").visible = true
		
	if new_tower.upgrade_value == null:
		new_tower.get_node("ButtonContainer/Upgrade").visible = false

func remove_tower_glow(old_tower):
		old_tower.get_node("TurretBase").set_material(null)
		old_tower.get_node("FacingDirection/TurretSprite").set_material(null)
		old_tower.get_node("ButtonContainer").visible = false

	
func get_selected_tower():
	return(selected_tower)
func create_select_box(mouse_start):
	
	var new_select_box = load("res://src/scenes/SelectBox.tscn").instance()
	
	$UserInterface.add_child(new_select_box)
	
	new_select_box.global_position = mouse_start
	
	select_box = new_select_box

func maintain_select_box(mouse_pos):
	var select_shape = select_box.get_node("CollisionShape2D")
	var origin = select_box.global_position
	var viewport_size = get_viewport_rect().size
	var camera_offset = $Camera2D.position - (viewport_size/2)
	var zoom = $Camera2D.zoom
	var zoom_scale = zoom.x
	var zoom_offset = zoom - Vector2(1,1) #??? No idea if this is useful, or if is, how to use it
	var distance = (mouse_pos - origin)
	
	#brackets below help me know the part that works minus zoom
	select_shape.shape.extents = (distance/2)
	select_shape.position = (select_shape.shape.extents - camera_offset)

func use_select_box():
	var temp_all_bodies = select_box.get_overlapping_bodies()
	var temp_towers = []
	
	for body in temp_all_bodies:
		if body.type == "tower":
			temp_towers.append(body)
	
#	selected_array = temp_towers
	if temp_towers.size() > 0:
		mass_select_towers(temp_towers)
	select_box.free()
	select_box = null

func mass_select_towers(inc_towers):
	var type_array = []
	var sell_array = []
	var button_container = $UserInterface/ButtonContainer
	var upgrade_value = $UserInterface/ButtonContainer/Upgrade/CostValue
	var sell_value = $UserInterface/ButtonContainer/Sell/SellValue
	var total_sell = 0
	
	selected_tower = null
	selected_array = inc_towers
	#do the shit that makes them glow 
	for tower in selected_array:
		make_tower_glow(tower, "mass")
		total_sell = total_sell + tower.sell_value
		if type_array.find(tower.tower_type) == -1:
			type_array.append(tower.tower_type)
	
	var total_upgrade = selected_array[0].upgrade_value * (selected_array.size())
	#show sell and target method
	
	sell_value.text = "+$" + str(total_sell)
	
	if type_array.size() <= 1:
		upgrade_value.text = "-$" + str(total_upgrade)
		#show upgrade button
	
	button_container.rect_global_position = get_global_mouse_position()
	button_container.show()

func _on_DownArea_mouse_entered():
	camera_move_array[1] = 1


func _on_UpArea_mouse_entered():
	camera_move_array[0] = 1


func _on_UpArea_mouse_exited():
	if camera_move_array[0] == 1:
		camera_move_array[0] = 0


func _on_DownArea_mouse_exited():
	if camera_move_array[1] == 1:
		camera_move_array[1] = 0
