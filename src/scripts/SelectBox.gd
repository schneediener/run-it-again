extends Area2D
#
#onready var game_scene = get_node("/root/SceneHandler").game_scene
#var select_box = null
#var selected_array = []
#
#
#func _process(delta):
#	if select_box:
#		if is_instance_valid(select_box):
#			maintain_select_box(get_global_mouse_position())
#
#func _unhandled_input(event):
#	if event.is_action_just_pressed("ui_accept"):
#		if !select_box:
#			create_select_box(get_global_mouse_position())
#	if event.is_action_released("ui_accept"):
#		if select_box:
#			if is_instance_valid(select_box):
#				use_select_box()
#
#func create_select_box(mouse_start):
#
#	var new_select_box = load("res://src/scenes/SelectBox.tscn").instance()
#
#	$UserInterface.add_child(new_select_box)
#
#	new_select_box.global_position = mouse_start
#
#	select_box = new_select_box
#
#func maintain_select_box(mouse_pos):
#	var select_shape = select_box.get_node("CollisionShape2D")
#	var distance = select_shape.distance_to(mouse_pos)
#
#	select_shape.shape.extents += distance
#	select_shape.position += distance
#
#func use_select_box():
#	var temp_all_bodies = get_overlapping_bodies()
#	var temp_towers = []
#
#	for body in temp_all_bodies:
#		if body.type == "tower":
#			temp_towers.append(body)
#
##	selected_array = temp_towers
#	if temp_towers.size() > 0:
#		mass_select_towers(temp_towers)
#	select_box.free()
#	select_box = null
#
#func mass_select_towers(inc_towers):
#	var type_array = []
#	var sell_array = []
#	var button_container = $UserInterface/ButtonContainer
#	var upgrade_value = $UserInterface/ButtonContainer/Upgrade/CostValue
#	var sell_value = $UserInterface/ButtonContainer/Sell/SellValue
#
#	selected_tower = null
#	selected_array = inc_towers
#	#do the shit that makes them glow 
#	for tower in selected_array:
#		make_tower_glow(tower)
#		sell_array.append(tower.sell_value)
#		if type_array.find(tower.tower_type) == -1:
#			type_array.append(tower.tower_type)
#
#	var total_sell = sell_array.reduce()
#	var total_upgrade = selected_array[0].upgrade_value * (selected_array.size())
#	#show sell and target method
#
#	sell_value.text = "+$" + str(total_sell)
#
#	if type_array.size() <= 1:
#		upgrade_value.text = "-$" + str(self.total_upgrade)
#		#show upgrade button
#
#	button_container.global_position = get_global_mouse_position()
#	button_container.show()
