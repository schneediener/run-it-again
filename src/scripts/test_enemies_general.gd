extends "res://src/scripts/temporal_engine.gd"

class_name EnemyGeneral

var health
var health_perc
var type = "enemy"
var subtype = "creep"
onready var time_freeze = false
var remaining_dist

onready var slow_timer = $SlowTimer
var slowed = false

onready var game_scene = get_node("/root/SceneHandler").game_scene
#onready var path #= game_scene.map_node.get_node("Path2D")
#onready var path_follow #= path.get_node("PathFollow2D")

#var sean_test = true

func _ready():
	
	self.speed = self.speed
	$HealthBar.value = self.max_health
	$HealthBar.max_value = self.max_health
	health=self.max_health
	calculate_health_perc()
	set_health_tint()
#	print(global_position)
	
func _physics_process(delta):
	
#	
#	if path.curve.get_baked_points().size() > 0:
#		calc_remaining_dist(self)
#		var target = global_position.direction_to(path[0])
#		velocity = move_and_slide(target * self.speed) * delta
#		var path_distance = global_position.distance_to(path[0])
#		if path_distance <= 16:
#			path.remove(0)
	
	if $HealthBar.value != health:
		$HealthBar.value = health
		calculate_health_perc()
		set_health_tint()
		
	#print (distance_travelled)
func calculate_health_perc():
#	var perc = (health/self.max_health)*100
	var perc = round((float(health)/self.max_health)* 100)
	health_perc = perc


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
	
	if health <= 0 and !dead:
		dead = true
		new_gold = game_scene.map_node.income_per_kill*self.gold_multi
		if game_scene.current_time < game_scene.time_max:
			game_scene.current_time = game_scene.current_time + 0.8
		
		game_scene.current_gold = game_scene.current_gold+new_gold
		print(new_gold)
		self.queue_free()


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
