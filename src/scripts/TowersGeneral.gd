extends Node2D

var enemy_array = []
var built = true
var select_mode = "first"
onready var enemy# = get_node("../../../SeanMap/TestEnemy")
onready var enemy_script = load("res://src/scripts/test_enemy.gd").new()

func _physics_process(_delta):
	if enemy_array.size() >= 1 and built:
		select_enemy(select_mode)
		track_enemy()

func select_enemy(select_mode):
	var enemy_progress_array = []
	for i in enemy_array:
		var path_distance = i.get_distance()
		enemy_progress_array.append(path_distance)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]
	
#	if global_position.distance_to(path[0]) <= 16:
#			path.remove(0)

func track_enemy():
	#for the animation of the turret aiming at the enemy
	var enemy_position = enemy.position
	#print (enemy)
	if enemy:
		$FacingDirection.look_at(enemy_position)


func fire_primary():
	#for firing the towers primary weapon
	pass


func _on_Range_body_entered(body):
	
	enemy_array.append(body)
	print ("entered")



func _on_Range_body_exited(body):
	enemy_array.erase(body)
	print("left")

