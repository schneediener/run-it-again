extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
#onready var character: KinematicBody2D = $TestEnemy
onready var line_2d: Line2D = $Line2D

var path
onready var end_point = get_node("ExitPoint").position
export var income_per_wave = 50
export var income_per_kill = 5
var max_waves = 6


#Array is as follows: Wave Number, Lvl 1 Enemies per wave, Lvl 2 Enemies.. , Lvl 3 Enemies..
export var wave_1_array = [1,10,0,0]
var wave_2_array = [2,10,5,0]
var wave_3_array = [3,15,5,1]
var wave_4_array = [4,10,10,3]
var wave_5_array = [5,5,15,5]
var wave_6_array = [6,0,10,10]
var wave_7_array
var wave_8_array
var wave_9_array
var wave_10_array

var current_wave = wave_1_array

var lvl1_max_enemies = current_wave[1]
var lvl2_max_enemies = current_wave[2]
var lvl3_max_enemies = current_wave[3]

var lvl1_spawned
var lvl2_spawned
var lvl3_spawned

func _ready():
	pass

func spawn_new_enemy():
	var load_enemy = load("res://src/scenes/enemies/SlowEnemy.tscn").instance()
	
	$EnemyContainer.add_child(load_enemy, true)
	load_enemy.global_position = $Spawn.position
	
	if path:
		load_enemy.path = path
	else:
		create_path(load_enemy)
	

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
