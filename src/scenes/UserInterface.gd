extends CanvasLayer

func set_tower_preview(tower_type, mouse_position):
	print (tower_type)
	
	var drag_tower = load("res://src/scenes/towers/" + tower_type + "T1.tscn").instance()
	
# Method for setting drag_tower by name doesn't feel good, but it's cleaner than my alternative at the moment, see below
#	var drag_tower = null
#	if tower_type == "gun":
#		drag_tower = load("res://src/scenes/towers/GunT1.tscn").instance()
#	else:
#		drag_tower = load("res://src/scenes/towers/MissileT1.tscn").instance()

	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)
	get_node("TowerPreview/DragTower/Range").visible = true

func update_tower_preview(new_position, color):
	var tower_preview = get_node("TowerPreview")
	var drag_tower = get_node("TowerPreview/DragTower")
	
	tower_preview.rect_position = new_position
	if drag_tower.modulate != Color(color):
		drag_tower.modulate = Color(color)
