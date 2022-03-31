extends KinematicBody2D

var enemy_array = []
var built = true
var select_mode = "first"
onready var enemy = get_node("../TestEnemy")

func _physics_process(_delta):
#	if enemy_array.size >= 1 and built:
#		select_enemy(select_mode)
		track_enemy()

func select_enemy(select_mode):
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func track_enemy():
	#for the animation of the turret aiming at the enemy
	
	#print (enemy)
	self.look_at(enemy.position)


func fire_primary():
	#for firing the towers primary weapon
	pass


func _on_Range_body_entered(body):
	
	enemy_array.append(body)



func _on_Range_body_exited(body):
	enemy_array.erase(body)

