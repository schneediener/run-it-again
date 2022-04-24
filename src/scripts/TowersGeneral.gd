extends Node2D

var enemy_array = []
var built = false
var select_mode = "first"
onready var enemy# = get_node("../../../SeanMap/TestEnemy")
onready var enemy_script = load("res://src/scripts/test_enemy1.gd").new()
var bullet
var speed = 200
onready var ready_to_fire = true
onready var game_scene = get_node("../../..")

func _ready():
#	print("modulate:" + str(self.modulate))
	#$Upgrade.visible = false
	#print("ready finished")
	
	if built:
		$ButtonContainer/Upgrade/CostValue.text = "-$" + str(self.upgrade_value)
		$ButtonContainer/Sell/SellValue.text = "+$" + str(self.sell_value)

func _physics_process(_delta):
	maintain_upgrade_button()
	if enemy_array.size() >= 1 and built:
		select_enemy(select_mode)
		track_enemy()
		if ready_to_fire == true:
			fire_primary()
#	if game_scene.selected_tower != self and $Upgrade.visible:
#		$Upgrade.visible = false

func maintain_upgrade_button():
	var button = $ButtonContainer/Upgrade
	var status
	
	if $ButtonContainer.visible and self.upgrade_value:
		if game_scene.current_gold < self.upgrade_value:
			status = "disabled"
		else:
			status = "enabled"
		if status == "disabled" and button.modulate == Color(1,1,1,1):
			button.modulate = (Color(0.44,0.44,0.44,1))
		if status == "enabled" and button.modulate != Color(1,1,1,1):
			button.modulate = Color(1,1,1,1)

func _on_FiringRate_timeout():
	ready_to_fire = true

func select_enemy(select_mode):
	var enemy_progress_array = []
	for i in enemy_array:
		var path_distance = i.get_distance()
		enemy_progress_array.append(path_distance)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	if enemy != enemy_array[enemy_index]:
		for n in $FacingDirection/BulletContainer.get_children():
			n.free()
		enemy = enemy_array[enemy_index]
	
	
#	if global_position.distance_to(path[0]) <= 16:
#			path.remove(0)
func _on_Sell_pressed():
	var tower_exclusion = game_scene.map_node.get_node("Navigation2D/TowerExclusion")
	var current_tile = tower_exclusion.world_to_map(self.position)
	
	if built and self.sell_value:
		game_scene.current_gold_set(game_scene.current_gold+self.sell_value)
		game_scene.selected_tower = null
		game_scene.map_node.get_node("Navigation2D/TowerExclusion").set_cellv(current_tile, -1)
		self.queue_free()

func _on_Upgrade_pressed():
	var current_tower = self
	var new_tower = current_tower.upgrade_path.instance()
	var cost = current_tower.upgrade_value
	var current_gold = game_scene.current_gold
	
	if new_tower and game_scene.current_gold >= cost:
		
		game_scene.current_gold_set(current_gold-cost)
		
		self.get_parent().add_child(new_tower, true)
		new_tower.position = current_tower.position
		new_tower.built = true
		game_scene.selected_tower = null
		self.queue_free()
	
	pass
	
func track_enemy():
	#for the animation of the turret aiming at the enemy
	var enemy_position = enemy.position
	#print (enemy)
	if enemy:
		$FacingDirection.look_at(enemy_position)

func _on_SelectTower_pressed():
#	print("select button pressed!")
	
	game_scene.select_tower(self)

#func _on_SelectArea_input_event(viewport, event, shape_idx):
#
#	if event is InputEventMouseButton \
#	and event.button_index == BUTTON_LEFT \
#	and event.pressed:
#		if game_scene.sell_mode:
#			game_scene.sell_tower(self)
#		else:
#			game_scene.select_tower(self)



func fire_primary():
	if enemy and ready_to_fire:
		
		var bullet = load("res://src/scenes/towers/Bullet.tscn").instance()
		$FacingDirection/BulletContainer.add_child(bullet, false)
		bullet.global_position = $FacingDirection/MuzzlePosition1.global_position
#		bullet.destination = enemy.position
		ready_to_fire = false
		$FiringRate.start()

func _on_Range_body_entered(body):

	if body.is_in_group("bullets"):
		pass
	else:
		enemy_array.append(body)
#		print ("entered")


#func _on_SelectArea_input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton \
#	and event.button_index == BUTTON_LEFT \
#	and event.pressed:
#		print("Clicked")
#		return(self) # returns a reference to this node

func _on_Range_body_exited(body):
	if body.is_in_group("bullets"):
		pass
	else:
		enemy_array.erase(body)
#		print("left")

