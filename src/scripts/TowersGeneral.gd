extends Node2D

var enemy_array = []
var built = false
var select_mode = "first"
onready var enemy# = get_node("../../../SeanMap/TestEnemy")
onready var enemy_script = load("res://src/scripts/test_enemy.gd").new()
var bullet
var speed = 200
onready var ready_to_fire = true
onready var game_scene = get_node("../../..")

func _ready():
	$Upgrade.visible = false
	print("ready finished")

func _physics_process(_delta):
	
	if enemy_array.size() >= 1 and built:
		select_enemy(select_mode)
		track_enemy()
		if ready_to_fire == true:
			fire_primary()
	if game_scene.selected_tower != self and $Upgrade.visible:
		$Upgrade.visible = false

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

func _on_Upgrade_pressed():
	pass
	
func track_enemy():
	#for the animation of the turret aiming at the enemy
	var enemy_position = enemy.position
	#print (enemy)
	if enemy:
		$FacingDirection.look_at(enemy_position)

func _on_SelectArea_pressed():
	print("select button pressed!")
	if game_scene.sell_mode:
			game_scene.sell_tower(self)
	else:
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
		print ("entered")


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
		print("left")

