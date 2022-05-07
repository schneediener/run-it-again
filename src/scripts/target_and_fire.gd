extends Node

var weapon_range
var weapon_type
onready var target_method = "first"
var current_target
var target_array = []
onready var game_scene = get_node("/root/SceneHandler/GameScene")
onready var ready = true

signal array_refreshed
signal target_acquired

func _physics_process(delta):
	refresh_target_array()
	if current_target:
		track_target()

func track_target():
	$FacingDirection.look_at(current_target.position)

func refresh_target_array():
	var temp_targets = weapon_range.get_overlapping_bodies()
	
	for body in temp_targets:
		if body.type != "enemy":
			temp_targets.erase(body)

	target_array = temp_targets
	
	emit_signal("array_refreshed")

func _on_array_refreshed():
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
		"last":
			primary_stat = "distance"
		"dropship":
			primary_stat = "dropship"
			primary_array = all_dropship_array
		_:
			push_error("Unknown target method")
			return
	#Gather all primary stats
	for enemy in target_array:
			match primary_stat:
				"distance":
					all_dist_array.append(enemy.get_distance())
				"health":
					all_health_array.append(enemy.health)
				"speed":
					all_speed_array.append(enemy.speed)
				"dropship":
					all_dropship_array.append(enemy)
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
			pass
		_:
			push_error("Error determining min/max targets")
			return

	#For dist, select target
	#For others, fill stat array
	for enemy in target_array: #use target method to determine target
		if enemy.subtype=="creep":
			match primary_stat:
				"distance":
					if target_method == "first" and \
					enemy.get_distance() == smallest_distance:
						current_target = enemy
						emit_signal("target_acquired")
						return
					if target_method == "last" and \
					enemy.get_distance() == largest_distance:
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
	
	match weapon_type:
		"cannon":
			projectile = load("res://src/scenes/projectiles/Bullet.tscn").instance()
		"missile":
			projectile = load("res://src/scenes/projectiles/Missile.tscn").instance()
			projectile.start(muzzle.global_transform, current_target, self)
		"gun":
			current_target.health = current_target.health-self.damage
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
		
	yield(get_tree().create_timer(0.1), "timeout")
	
	flash_sprite1.hide()
	
	if flash_sprite2:
		flash_sprite2.hide()

func _on_FiringRate_timeout():
	ready = true
