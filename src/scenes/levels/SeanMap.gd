extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
#onready var character: KinematicBody2D = $TestEnemy
onready var line_2d: Line2D = $Line2D

onready var game_scene = get_node("../")
var path
onready var end_point = get_node("ExitPoint").position

export var income_per_wave = 50
export var income_per_kill = 1
var max_waves = 6
var ready_to_finish


#Array is as follows: Wave Number, Lvl 1 Enemies per wave, Lvl 2 Enemies.. , Lvl 3 Enemies..

export var wave_1 = ["Wave 1",10,0,0,1]
export var wave_2 = ["Wave 2",15,5,0,0.9]
export var wave_3 = ["Wave 3",15,5,1,0.8]
export var wave_4 = ["Wave 4",15,10,3,0.7]
export var wave_5 = ["Wave 5",15,15,5,0.6]
export var wave_6 = ["Wave 6",20,10,10,.5]


var enemy_roulette = []

var wave_list = ["start", wave_1, wave_2, wave_3, wave_4, wave_5, wave_6, "finish"]

onready var current_wave = wave_list[0]

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
	if ready_to_finish and $EnemyContainer.get_child_count()==0:
		
		finish_level()
		ready_to_finish = false

func start_new_wave():
	$Spawn/Timer.stop()
	
	$Spawn/Timer.wait_time = float(current_wave[4])
	print(str($Spawn/Timer.wait_time))

	wave_list.erase(current_wave)
	#not sure if ill need to wait between actions here
	if wave_list.empty() == false:
		current_wave = wave_list[0]
		if current_wave and str(current_wave) != "finish":
			update_wave_counters()
			
			$WaveTimer.wait_time = 10
			$WaveTimer.start()
			
			yield($WaveTimer, "timeout")
			
			populate_roulette()
			$Spawn/Timer.emit_signal("timeout")
			$Spawn/Timer.start()
		elif current_wave == "finish":
			ready_to_finish = true
	else:
		ready_to_finish = true
	

	
	
func finish_level():
	$WaveTimer.wait_time = 2
	$WaveTimer.start()
	
	yield($WaveTimer, "timeout")
	
	OS.alert("Congratulations! You won!", "Victory")
	get_tree().quit()

func update_wave_counters():
	lvl1_max = current_wave[1]
	lvl2_max = current_wave[2]
	lvl3_max = current_wave[3]
	
	total_max = lvl1_max+lvl2_max+lvl3_max
	total_spawned = 0

func populate_roulette():
	if str(current_wave) != "start" or "finish":
		for i in range(lvl1_max):
			enemy_roulette.append("1")
		for i in range(lvl2_max):
			enemy_roulette.append("2")
		for i in range(lvl3_max):
			enemy_roulette.append("3")

func spawn_new_enemy():
	var slow = load("res://src/scenes/enemies/SlowEnemy.tscn")
	var fast = load("res://src/scenes/enemies/FastEnemy.tscn")
	var basic = load("res://src/scenes/enemies/BasicEnemy.tscn")
	var next_enemy
	var spawn_1 = $Spawn
	var spawn_2 = $Spawn/Spawn_2
	var next_spawn
	
	if enemy_roulette.empty():
		game_scene.current_gold=game_scene.current_gold+income_per_wave
		start_new_wave()
		return
	
	var next_type = enemy_roulette[randi() % enemy_roulette.size()]
	
	match next_type:
		"1":
			next_enemy = basic.instance()
		"2":
			next_enemy = slow.instance()
		"3":
			next_enemy = fast.instance()
		_:
			push_error("enemy type unknown during spawn_new_enemy")
	
	if next_enemy:
		$EnemyContainer.add_child(next_enemy, true)
		
		next_spawn = randi() % 3 + 1
		if next_spawn != 3:
			next_enemy.global_position = spawn_1.position
		else:
			next_enemy.global_position = spawn_2.position
		enemy_roulette.erase(next_type)
		
		create_path(next_enemy)
	else:
		push_error("no enemy")
	

func create_path(character):
	yield(get_tree(), "idle_frame")
	#print(character.global_position)
	var path = nav_2d.get_simple_path(character.global_position, end_point, true)
	#print(path)
	character.path = path
	line_2d.points = path
	#print (line_2d.points)

#func give_path(enemy):
#	enemy.path = path




func _on_Timer_timeout():
	spawn_new_enemy()


func _on_DamageZone_body_entered(body):
	pass # Replace with function body.
