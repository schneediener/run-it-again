extends KinematicBody2D

var enemy_array = []
onready var enemy = get_node("../TestEnemy")

func _physics_process(_delta):
	track_enemy()

func track_enemy():
	#for the animation of the turret aiming at the enemy
	pass
	#print (enemy)
	self.look_at(enemy.position)


func fire_primary():
	#for firing the towers primary weapon
	pass


func _on_Range_body_entered(body):
	
	enemy_array.append(body)
	print (enemy_array)
	pass # Replace with function body.


func _on_Range_body_exited(body):
	enemy_array.erase(body)
	print (enemy_array)
	print ("cleared")
	pass # Replace with function body.
