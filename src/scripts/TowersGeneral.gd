extends Node2D

var built = false
onready var target_method = "first"
var current_target
var target_array = []
onready var weapon_range = $Range
onready var ready = true
onready var game_scene = get_node("/root/SceneHandler/GameScene")
var type = "tower"

signal array_refreshed
signal target_acquired

func _ready():
	$FiringRate.wait_time = ($FiringRate.wait_time / 2)
	#old code below
	$ButtonContainer.hide()
	$ButtonContainer/Upgrade/CostValue.text = "-$" + str(self.upgrade_value)
	$ButtonContainer/Sell/SellValue.text = "+$" + str(self.sell_value)
	#new code below
	self.connect("array_refreshed", self, "_on_array_refreshed")
	self.connect("target_acquired", self, "_on_target_acquired")

func _physics_process(_delta):
	#old code below
	if game_scene.selected_tower == self:
			$Range/RangeSprite.show()
	elif built:
		if $Range/RangeSprite.visible:
			$Range/RangeSprite.hide()
	maintain_upgrade_button()
	
	#new code below
	if built:
		refresh_target_array()
		if current_target:
			track_target()

func maintain_upgrade_button(): #old function
	#old code below
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

func track_target():
	$FacingDirection.look_at(current_target.global_position)

func refresh_target_array():
	#new code below
	var overlapping_targets = weapon_range.get_overlapping_bodies()
	var temp_targets = []
	
	target_array = []
	
	for body in overlapping_targets:
		if body.type == "enemy":
			temp_targets.append(body)
	
	target_array = temp_targets
	
	emit_signal("array_refreshed")

func _on_array_refreshed():
	if target_array.size() > 0:
		select_target()

func select_target():
	var all_dist_array = []
	var all_health_array = []
	var all_speed_array = []
	var all_dropship_array = []
	var primary_array
	var primary_stat
	
	var smallest_distance
	var largest_distance
	
	var weakest_health
	var weakest_array = []
	
	var strongest_health
	var strongest_array = []
	
	var slowest_speed
	var slowest_array = []
	
	var fastest_speed
	var fastest_array = []
	
	#Do not bother with calcs if there's only one target
	if target_array.size()==1:
		current_target = target_array[0]
		emit_signal("target_acquired")
		return
	else:
		current_target = null
	
	#if there is more than one target, continue to determine primary stat/array
	match target_method:
		"weak":
			primary_array = weakest_array
			primary_stat = "health"
		"strong":
			primary_array = strongest_array
			primary_stat = "health"
		"fast":
			primary_array = fastest_array
			primary_stat = "speed"
		"slow":
			primary_array = slowest_array
			primary_stat = "speed"
		"first":
			primary_stat = "distance"
			primary_array = target_array
		"last":
			primary_stat = "distance"
			primary_array = target_array
		"dropship":
			primary_stat = "dropship"
			primary_array = all_dropship_array
		_:
			push_error("Unknown target method")
			return
	#Gather all primary stats
	for enemy in target_array:
		if target_method=="dropship":
			if enemy.subtype=="dropship":
				all_health_array.append(enemy.get_health())
				all_dropship_array.append(enemy)
			else:
				all_dist_array.append(enemy.get_distance())
		else:
			if enemy.subtype=="creep":
				match primary_stat:
					"distance":
						all_dist_array.append(enemy.get_distance())
					"health":
						all_health_array.append(enemy.health)
					"speed":
						all_speed_array.append(enemy.speed)
					_:
						push_error("Error filling all arrays")
						return
	
	#set highest/lowest targets for primary array
	match primary_stat:
		"distance":
			smallest_distance = all_dist_array.min()
			largest_distance = all_dist_array.max()
		"health":
			weakest_health = all_health_array.min()
			strongest_health = all_health_array.max()
		"speed":
			slowest_speed = all_speed_array.min()
			fastest_speed = all_speed_array.max()
		"dropship":
			weakest_health = all_health_array.min()
			smallest_distance = all_dist_array.min()
		_:
			push_error("Error determining min/max targets")
			return


	if target_method=="dropship":
		for enemy in target_array: 
			if enemy.subtype=="dropship":
				if enemy.get_health()==weakest_health:
					weakest_array.append(enemy)
		
		if weakest_array.size()>0:
			for enemy in weakest_array:
				if enemy.get_health()==weakest_health:
					current_target = enemy
					emit_signal("target_acquired")
					return
		else:
			primary_stat="distance"
			
	#For dist, select target
	#For others, fill stat array
	for enemy in target_array:
		if enemy.subtype=="creep":
			match primary_stat: #use target method to determine target
				"distance":
					if target_method != "last":
						if enemy.remaining_dist == smallest_distance:
							current_target = enemy
							emit_signal("target_acquired")
							return
					if target_method == "last" and \
					enemy.remaining_dist == largest_distance:
						current_target = enemy
						emit_signal("target_acquired")
						return
				"health":
					if target_method == "weak" and \
					enemy.health == weakest_health:
						weakest_array.append(enemy)
					if target_method == "strong" and \
					enemy.health == strongest_health:
						strongest_array.append(enemy)
				"speed":
					if target_method == "slow" and \
					enemy.speed == slowest_speed:
						slowest_array.append(enemy)
					if target_method == "fast" and \
					enemy.speed == fastest_speed:
						fastest_array.append(enemy)
				_:
					push_error("Error appending to primary array")
					return
	
	#If there's only one target, target it
	if primary_array.size()==1:
		current_target = primary_array[0]
		emit_signal("target_acquired")
		return
	elif primary_array.size() > 1: #If more than one target has min/max primary stat, find their distances
		if primary_array[0].subtype == "creep":
			all_dist_array = []
			for enemy in primary_array:
				all_dist_array.append(enemy.get_distance())
		elif primary_array == all_dropship_array:
			all_health_array = []
			for enemy in primary_array:
				all_health_array.append(enemy.health)
		else:
			push_error("Error checking prim array single-target, or refreshing dist array")
			return
	
	#Set "min" target
	if primary_array != all_dropship_array:
		smallest_distance = all_dist_array[0]
	else:
		weakest_health = all_health_array.min()
	
	#Of all enemies with the target primary stat, find the "closest" and target it
	for enemy in primary_array:
		if primary_array != all_dropship_array:
			if enemy.get_distance()==smallest_distance:
				current_target = enemy
				emit_signal("target_acquired")
				return
		else:
			if enemy.health==weakest_health:
				current_target = enemy
				emit_signal("target_acquired")
				return
	
	#If by this point, a return hasn't been hit, throw an error
	push_error("Error determining target by end of script")

func _on_target_acquired():
	if ready:
		fire()

func fire():
	var projectile_container = game_scene.map_node.get_node("BulletContainer")
	var projectile
	var muzzle = self.get_node("FacingDirection/Muzzle")
	var cooldown = self.get_node("FiringRate")
	
	match self.weapon_type:
		"cannon":
			projectile = load("res://src/scenes/projectiles/Bullet.tscn").instance()
			projectile.start(muzzle.global_position, current_target, self)
		"missile":
			$FacingDirection.look_at(current_target.global_position)
			projectile = load("res://src/scenes/projectiles/Missile.tscn").instance()
			projectile.start(muzzle.global_transform, current_target, self)
		"gun":
			if current_target.subtype=="creep":
				current_target.take_damage(self.damage, true)
			elif current_target.subtype=="dropship":
				current_target.take_damage(self.damage, false)
			#to-do: current_target.play_gun_hit_animation()
		"laser":
			pass #shoot the laser
		"artillery":
			pass #lob the shell
	
	if projectile:
		projectile_container.add_child(projectile)
	
	flash()
	ready = false
	cooldown.start()

func flash():
	var flash_sprite1 = get_node("FacingDirection/Muzzle/Flash")
	var flash_sprite2
	
	if self.muzzle_count == 2:
		flash_sprite2 = get_node("FacingDirection/Muzzle2/Flash")
	
	flash_sprite1.show()
	
	if flash_sprite2:
		flash_sprite2.show()
		
	yield(get_tree().create_timer(0.05), "timeout")
	
	flash_sprite1.hide()
	
	if flash_sprite2:
		flash_sprite2.hide()

func _on_FiringRate_timeout():
	ready = true

func _on_Sell_pressed(): #old function
	var tower_exclusion = game_scene.map_node.get_node("Navigation2D/TowerExclusion")
	var current_tile = tower_exclusion.world_to_map(self.position)
	
	if built and self.sell_value:
		game_scene.current_gold_set(game_scene.current_gold+self.sell_value)
		game_scene.selected_tower = null
		game_scene.map_node.get_node("Navigation2D/TowerExclusion").set_cellv(current_tile, -1)
		self.queue_free()

func _on_Upgrade_pressed(): #old function
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

func _on_SelectTower_pressed(): #old function
	game_scene.select_tower(self)


func _on_Range_body_exited(body):
	if current_target==body:
		current_target = null

func _on_TargetOption_item_selected(index):
	match index:
		0:
			target_method = "first"
		1:
			target_method = "last"
		2:
			target_method = "strong"
		3:
			target_method = "weak"
		4:
			target_method = "fast"
		5:
			target_method = "slow"
		6:
			target_method = "dropship"
		_:
			push_error("Error setting target method on tower")
