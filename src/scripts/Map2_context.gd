extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
#onready var character: KinematicBody2D = $TestEnemy
onready var line_2d: Line2D = $Line2D

onready var game_scene = get_node("../")
onready var path = $Path2D
onready var end_point_left = get_node("ExitPointLeft").position
onready var end_point_right = get_node("ExitPointRight").position

export var income_per_wave = 150
export var income_per_kill = 15
var max_waves = 6
var ready_to_finish

var middle_last_spawned
onready var infantry_spawn = $InfantrySpawn

onready var ship_path_1 = $Dropships/Path_Dropship1
onready var ship_path_2 = $Dropships/Path_Dropship2
onready var ship_path_3 = $Dropships/Path_Dropship3
onready var ship_path_4 = $Dropships/Path_Dropship4


#Array is as follows: Wave Number, Lvl 1 Enemies per wave, lvl 2, lvl3, spawn time

export var wave_1 = ["Wave 1",20,0,0,0.5]
export var wave_2 = ["Wave 2",30,10,0,0.4]
export var wave_3 = ["Wave 3",30,16,0,0.3]
export var wave_4 = ["Wave 4",30,16,2,0.3]
export var wave_5 = ["Wave 5",30,6,4,0.2]
export var wave_6 = ["Wave 6",30,6,4,0.2]
export var wave_7 = ["Wave 7",30,20,6,0.2]
export var wave_8 = ["Wave 8",50,30,10,0.2]
export var wave_9 = ["Wave 9",60,30,30,0.2]
export var finale = ["Finale",60,45,45,0.2]

var mission_complete = false

var view_points
var enemy_roulette = []

var wave_list = ["start", wave_1, wave_2, wave_3, wave_4, wave_5, wave_6, wave_7, wave_8, wave_9, finale]

onready var current_wave = wave_list[0]

var finish_type

var lvl1_max
var lvl2_max
var lvl3_max

var lvl1_spawned
var lvl2_spawned
var lvl3_spawned

var total_max
var total_spawned

func _ready():
	
	$WaveTimer.wait_time = 5
	$WaveTimer.start()
	yield ($WaveTimer, "timeout")
	start_new_wave()
	pass

func _process(_delta):
	if ready_to_finish:
		if $EnemyContainer.get_child_count()==0:
			finish_level(finish_type)
			ready_to_finish = false

#SEANS TEST SHIT
#func initial_path_creation(spawn, end):
#	var temp_path = nav_2d.get_simple_path(spawn, end, true)
#	for i in temp_path:
#		$Path2D.curve.add_point(i)
#
#	view_points = $Path2D.curve.get_baked_points()
#	pass
func start_new_wave():
	$Spawn/Timer.stop()
	
	
	if current_wave[0] != "Finale":
		wave_list.erase(current_wave)
	#not sure if ill need to wait between actions here
	if wave_list.empty() == false:
		current_wave = wave_list[0]
		if wave_list.size()>1:
			$Spawn/Timer.wait_time = float(current_wave[4])
		if current_wave[0] == "Wave 3" or current_wave[0] == "Wave 6" or current_wave[0] == "Wave 8":
			spawn_dropship()
		if current_wave[0] != "Finale":
			update_wave_counters()
			
			$WaveTimer.wait_time = 10
			$WaveTimer.start()
			
			yield($WaveTimer, "timeout")
			game_scene.get_node("UserInterface/WavePanel/WaveCounter").text = current_wave[0]
			populate_roulette()
			$Spawn/Timer.emit_signal("timeout")
			$Spawn/Timer.start()
		elif current_wave[0] == "Finale":
			if mission_complete:
				ready_to_finish = true
	
func spawn_dropship():
	var dropship = load("res://src/scenes/enemies/Dropship_Test.tscn").instance()
	randomize()
	var landing_site = randi() % 4 + 1
	print(landing_site)
	
	match landing_site:
		1:
			ship_path_1.add_child(dropship)
			dropship.endpoint = "left"
		2:
			ship_path_2.add_child(dropship)
			dropship.endpoint = "right"
		3:
			ship_path_3.add_child(dropship)
			dropship.endpoint = "middle"
		4: 
			ship_path_4.add_child(dropship)
			dropship.endpoint = "middle"
	
func finish_level(type):
	get_tree().paused = true
	game_scene.ending_popup.show()
	if type == "good":
		pass
#		OS.alert("Congratulations! You won!", "Victory")
	else:
		game_scene.ending_popup.label_text = "MISSION FAILED"

func update_wave_counters():
	lvl1_max = current_wave[1]
	lvl2_max = current_wave[2]
	lvl3_max = current_wave[3]
	
	total_max = lvl1_max+lvl2_max+lvl3_max
	total_spawned = 0

func populate_roulette():
	if str(current_wave) != "start" or "finish":
		for _i in range(lvl1_max):
			enemy_roulette.append("1")
		for _i in range(lvl2_max):
			enemy_roulette.append("2")
		for _i in range(lvl3_max):
			enemy_roulette.append("3")

func spawn_new_enemy():
	var slow = load("res://src/scenes/enemies/SlowEnemy.tscn")
	var fast = load("res://src/scenes/enemies/FastEnemy.tscn")
#	var basic = load("res://src/scenes/enemies/BasicEnemy.tscn")
	var basic = load("res://src/scenes/enemies/ContextEnemy.tscn")
	var _tank = load("res://src/scenes/enemies/Tank.tscn")
	
#	initial_path_creation($Spawn.global_position, $ExitPointLeft.global_position)
	
	var next_enemy
	var spawn_1 = $Spawn
	var spawn_2 = $Spawn/Spawn_2
	var spawn_3 = $Spawn/Spawn_3
	var next_spawn
	
	if enemy_roulette.empty():
		game_scene.current_gold=game_scene.current_gold+income_per_wave
		game_scene.get_node("UserInterface/WavePanel/EnemyCounter").text = "0 units remaining"
		start_new_wave()
		return
	
	var next_type = enemy_roulette[randi() % enemy_roulette.size()]
	
	match next_type:
		"1":
			next_enemy = basic
		"2":
			next_enemy = slow
		"3":
			next_enemy = fast
		_:
			push_error("enemy type unknown during spawn_new_enemy")
	
	if next_enemy:
		next_spawn = randi() % 3 + 1
		next_enemy = next_enemy.instance()
		game_scene.get_node("UserInterface/WavePanel/EnemyCounter").text = str(enemy_roulette.size()) + " units remaining"
		var spawn_offset_randi = randi() % 5
		match next_spawn:
			1:
				next_enemy.global_position = (spawn_1.global_position + Vector2(0,spawn_offset_randi*30))
				
			2:
				next_enemy.global_position = (spawn_2.global_position + Vector2(0,spawn_offset_randi*30))
			3:
				next_enemy.global_position = (spawn_3.global_position + Vector2(0,spawn_offset_randi*30))
			_:
				push_error("error selecting spawn position")
		
		$EnemyContainer.add_child(next_enemy, true)
		enemy_roulette.erase(next_type)
		
		#create_path(next_enemy, next_spawn)
	else:
		push_error("no enemy")
	

#func create_path(character, spawn):
#	#yield(get_tree(), "idle_frame")
#	#print(character.global_position)
#	var path_left = nav_2d.get_simple_path(character.global_position, end_point_left, true)
#	var path_right = nav_2d.get_simple_path(character.global_position, end_point_right, true)
#	#print(path)
#	match spawn:
#		1, "left": 
#			character.path = path_left
#		2, "middle":
#			if middle_last_spawned == "left":
#				character.path = path_right
#				middle_last_spawned = "right"
#			else:
#				character.path = path_left
#				middle_last_spawned = "left"
#		3, "right":
#			character.path = path_right
	
#	line_2d.points = character.path
	#print (line_2d.points)

#func give_path(enemy):
#	enemy.path = path




func _on_Timer_timeout():
	spawn_new_enemy()
