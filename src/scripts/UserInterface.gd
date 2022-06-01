extends CanvasLayer
onready var game_scene = get_node("/root/SceneHandler").game_scene
onready var cannon_button = $HeadsUpDisplay/BuildPanel/HBox_BuildMenu/Cannon
onready var missile_button = $HeadsUpDisplay/BuildPanel/HBox_BuildMenu/Missile
onready var minigun_button = $HeadsUpDisplay/BuildPanel/HBox_BuildMenu/Minigun

func _physics_process(_delta):
	if is_instance_valid(game_scene):
		if game_scene.current_gold >= 150:
			if cannon_button.disabled:
				cannon_button.disabled = false
			if missile_button.disabled:
				missile_button.disabled = false
		else:
			if !cannon_button.disabled:
				cannon_button.disabled = true
			if !cannon_button.disabled:
				missile_button.disabled = true
		if game_scene.current_gold >= 175:
			if minigun_button.disabled:
				minigun_button.disabled = false
		else:
			if !minigun_button.disabled:
				minigun_button.disabled = true
		
		if game_scene.selected_array.size() > 0:
			$HeadsUpDisplay/SelectPanel.show()
		else:
			$HeadsUpDisplay/SelectPanel.hide()
#func set_tower_preview(tower_type, mouse_position):
##	print (tower_type)
#
#	var drag_tower = tower_type
#
## Method for setting drag_tower by name doesn't feel good, but it's cleaner than my alternative at the moment, see below
##	var drag_tower = null
##	if tower_type == "gun":
##		drag_tower = load("res://src/scenes/towers/GunT1.tscn").instance()
##	else:
##		drag_tower = load("res://src/scenes/towers/MissileT1.tscn").instance()
#	if drag_tower.get_node("SelectTower"):
#		drag_tower.get_node("SelectTower").visible = false
#
#	drag_tower.set_name("DragTower")
#	drag_tower.modulate = Color("ad54ff3c")
#
#	var control = Control.new()
#	control.add_child(drag_tower, true)
#	control.rect_position = mouse_position
#	control.set_name("TowerPreview")
#	add_child(control, true)
#	move_child(get_node("TowerPreview"), 0)
#	if get_node("TowerPreview/DragTower/Range"):
#		get_node("TowerPreview/DragTower/Range").visible = true
#
#func update_tower_preview(new_position, color):
#	var tower_preview = get_node("TowerPreview")
#	var drag_tower = get_node("TowerPreview/DragTower")
#
#	tower_preview.rect_position = get_parent().map_node.get_node("Navigation2D/TowerExclusion").to_local(new_position)
#	if drag_tower.modulate != Color(color):
#		drag_tower.modulate = Color(color)
