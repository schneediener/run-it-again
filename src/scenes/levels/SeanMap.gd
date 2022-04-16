extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
#onready var character: KinematicBody2D = $TestEnemy
onready var line_2d: Line2D = $Line2D

var path
var end_point = Vector2(1632, 1113)


func _ready():
	pass
	
func spawn_new_enemy():
	var load_enemy = load("res://src/scenes/enemies/TestEnemy.tscn").instance()
	
	$EnemyContainer.add_child(load_enemy, true)
	load_enemy.global_position = $Spawn.position
	if path:
		load_enemy.path = path
	else:
		create_path(load_enemy)
	

func create_path(character):
	yield(get_tree(), "idle_frame")
	print(character.global_position)
	var path = nav_2d.get_simple_path(character.global_position, end_point, true)
	print(path)
	character.path = path
	line_2d.points = path
	print (line_2d.points)

#func give_path(enemy):
#	enemy.path = path


func _on_Timer_timeout():
	spawn_new_enemy()
