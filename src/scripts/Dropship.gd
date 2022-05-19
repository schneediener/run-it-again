extends Node2D

var drop_point
var speed = 450
var health = 30
var shield = 10
var max_health = 250
var health_perc
var max_shield = 10
var type = "enemy"
var landing = false
var landed = false
var velocity
var gold_multi = 5

onready var game_scene = get_node("../../../../../")
#onready var enemy_script = preload("res://src/scripts/test_enemies_general.gd")

var wave_1 = ["Wave 1",10,0,0,0,1]
var wave_2 = ["Wave 2",10,3,0,0,.7]
var wave_3 = ["Wave 3",10,10,3,1,.7]
var wave_list = [wave_1,wave_2,wave_3]

var current_wave = null

func _ready():
	$HealthBar.value = self.max_health
	$HealthBar.max_value = self.max_health
	health=self.max_health
#	$HealthBar.set_as_toplevel(true)

func _physics_process(delta):
	$HealthBar.set_global_position(get_node("DropshipBody/ShipSprite").global_position+Vector2(-38,-62))
	calculate_health_perc()
	set_health_tint()
	# Move along the "path" if there is path left
	if get_parent().unit_offset!=1.0:
		get_parent().offset += speed * delta
	
	#If there is no path left, start landing
	if get_parent().unit_offset==1.0 and !landing:
		landing = true
	
	#If landing, but sprite hasn't moved down onto the shadow, move towards the shadow
	if landing:
		if $DropshipBody.global_position.distance_to($Shadow.global_position) > 2:
		
			velocity = $DropshipBody.global_position.direction_to($Shadow.global_position) * 180
			velocity = $DropshipBody.move_and_slide(velocity)
		
			#If dropship scale isn't yet at 0.8, slowly progress to 0.8 to create illusion of 3D "landing"
			if $DropshipBody.scale>Vector2(0.8, 0.8):
				$DropshipBody.set_scale($DropshipBody.scale-Vector2(0.005, 0.005))
		
		#Else, if position is close enough, and the ship isn't "landed" yet, set Landed to true and hide shadow/start spawning
		elif !landed:
			$Shadow.hide()
			$DropshipBody/Spawn/SpawnTimer.start()
			landed = true
			print("Ship has landed successfully")

func _on_SpawnTimer_timeout():
	if !current_wave:
		start_next_wave()
		health = health + 35
		return
		
	elif current_wave:
		if current_wave[1]>0:
			spawn_next_enemy("basic")
			current_wave[1] = current_wave[1]-1
			return
		elif current_wave[2]>0:
			spawn_next_enemy("slow")
			current_wave[2] = current_wave[2]-1
			return
		elif current_wave[3]>0:
			spawn_next_enemy("fast")
			current_wave[3] = current_wave[3]-1
			return
		elif current_wave[4]>0:
			spawn_next_enemy("tank")
			current_wave[4] = current_wave[4]-1
		else:
			wave_list.erase(current_wave)
			current_wave = null
	
func start_next_wave():
	if !current_wave and wave_list.size() > 0:
		$DropshipBody/Spawn/SpawnTimer.stop()
		current_wave = wave_list[0]
#		$DropshipBody/Spawn/SpawnTimer.wait_time = current_wave[5]
		yield(get_tree().create_timer(5.0), "timeout")
		$DropshipBody/Spawn/SpawnTimer.start()
		
func calculate_health_perc():
#	var perc = (health/self.max_health)*100
	var perc = round((float(health)/self.max_health)* 100)
	health_perc = perc
func set_health_tint():
	$HealthBar.visible = true
	if health_perc <= 99 and health_perc >= 50:
		$HealthBar.tint_progress = Color(0, 255, 0)
	elif health_perc <= 49 and health_perc >= 25:
		$HealthBar.tint_progress = Color(255, 255, 0)
	elif health_perc <=24:
		$HealthBar.tint_progress = Color(255, 0, 0)
	else:
		$HealthBar.visible = false
func spawn_next_enemy(temp_type):
	var new_enemy
	var enemy_container = game_scene.map_node.get_node("EnemyContainer")
	
	match temp_type:
		"basic":
			new_enemy = load("res://src/scenes/enemies/BasicEnemy.tscn").instance()
		"slow":
			new_enemy = load("res://src/scenes/enemies/SlowEnemy.tscn").instance()
		"fast":
			new_enemy = load("res://src/scenes/enemies/FastEnemy.tscn").instance()
		"tank":
			new_enemy = load("res://src/scenes/enemies/Tank.tscn").instance()
		_:
			push_error("enemy type unknown during spawn_next_enemy")
	
	if new_enemy:
		enemy_container.add_child(new_enemy)
		new_enemy.global_position = $DropshipBody/Spawn.global_position
		game_scene.map_node.create_path(new_enemy, 1)
