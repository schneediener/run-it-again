extends KinematicBody2D

var velocity = Vector2()
var path = PoolVector2Array()
var distance_travelled = 0
var health
var health_perc
var type = "enemy"
var subtype = "creep"
var remaining_dist = 0
onready var slow_timer = $SlowTimer
onready var just_leaked = false
var slowed = false
onready var orig_speed = self.speed

var recorded_payload
var recorded_outcome
var next_rec_interaction
var damage_instance_array = []
var spawn_point
var spawn_order
#var spawn_wave
var wave_hist
onready var game_scene = get_node("/root/SceneHandler").game_scene

var sean_test = true

func _ready():
	self.speed = self.speed
	$HealthBar.value = self.max_health
	$HealthBar.max_value = self.max_health
	health=self.max_health
	calculate_health_perc()
	set_health_tint()
#	print(global_position)
	
func _physics_process(delta):
	if slowed:
		self.speed = orig_speed*0.6
	else:
		self.speed = orig_speed
	if path.size() > 0:
		calc_remaining_dist(self)
		var target = global_position.direction_to(path[0])
		velocity = move_and_slide(target * self.speed) * delta
		var path_distance = global_position.distance_to(path[0])
		if path_distance <= 16:
			path.remove(0)
	
	if next_rec_interaction:
		if remaining_dist <= next_rec_interaction["distance"]:
			take_damage(next_rec_interaction["damage"], next_rec_interaction["slow"])
			var next_index = recorded_payload["interactions"].find(next_rec_interaction)+1
			if next_index != recorded_payload["interactions"].size():
				next_rec_interaction = recorded_payload["interactions"][next_index]
			else:
				next_rec_interaction = null
			
	
	if $HealthBar.value != health:
		$HealthBar.value = health
		calculate_health_perc()
		set_health_tint()
		
	#print (distance_travelled)
func calculate_health_perc():
#	var perc = (health/self.max_health)*100
	var perc = round((float(health)/self.max_health)* 100)
	health_perc = perc
	

func calc_remaining_dist(body):
	var temp_dist
	var curr_index = 0
	temp_dist = body.global_position.distance_to(path[0])
	
	for i in body.path:
		curr_index = curr_index+1
		if curr_index != body.path.size():
			var distance = i.distance_to(body.path[curr_index])
			temp_dist = temp_dist+distance
	
	body.remaining_dist=temp_dist

func set_health_tint():
	if health_perc == 100:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true
	if health_perc <= 80 and health_perc >= 50:
		$HealthBar.tint_progress = Color(0, 255, 0)
	elif health_perc <= 49 and health_perc >= 25:
		$HealthBar.tint_progress = Color(255, 255, 0)
	elif health_perc <=24:
		$HealthBar.tint_progress = Color(255, 0, 0)
	else:
		$HealthBar.visible = false
	
func get_distance():
	return remaining_dist

func take_damage(damage, slow):
	var dead
	var new_gold
	
	if slow and subtype=="creep":
		slow_timer.start()
		if !slowed:
			slowed = true
		
	health = health-damage
	
	var damage_dict = {"damage": damage, "distance": remaining_dist, "slow": slow}
	damage_instance_array.append(damage_dict)
	
	if health <= 0 and !dead:
		dead = true
		send_death_payload()
		if recorded_outcome == "leaked":
			game_scene.current_health += 1
		new_gold = game_scene.map_node.income_per_kill*self.gold_multi
		if game_scene.current_time < game_scene.time_max:
			game_scene.current_time = game_scene.current_time + 0.8
		
		game_scene.current_gold = game_scene.current_gold+new_gold
		self.queue_free()

func send_death_payload():
	var final_outcome
	if health <= 0:
		final_outcome = "dead"
	else:
		final_outcome = "leaked"
	
	var my_final_dict = {
	"spawn": spawn_point, 
	"order": spawn_order, 
	"type": self.creep_type, 
	"interactions":damage_instance_array,
	"outcome": final_outcome}
		
	wave_hist[spawn_order] = my_final_dict.duplicate()
	

func receive_death_payload(payload, prev_wave):
	recorded_payload = payload
	wave_hist = prev_wave
	spawn_point = payload["spawn"]
	spawn_order = payload["order"]
	recorded_outcome = payload["outcome"]
	next_rec_interaction = payload["interactions"][0]
	
	

func _on_SlowTimer_timeout():
	slowed = false

func _on_HitDetection_body_entered(body):
	
	if body.type == "bullet":
		if body.target==self:
			var damage = body.damage
			var slow
			if body.get("slow"):
				slow = true
			body.free()
			take_damage(damage, slow)
