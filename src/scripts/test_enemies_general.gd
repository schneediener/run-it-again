extends KinematicBody2D

var velocity = Vector2()
var path = PoolVector2Array()
var distance_travelled = 0
var health
var health_perc
var type = "enemy"
onready var game_scene = get_node("../../..")

func _ready():
	$HealthBar.value = self.max_health
	$HealthBar.max_value = self.max_health
	health=self.max_health
	calculate_health_perc()
	set_health_tint()
#	print(global_position)
	
func _physics_process(delta):
	distance_travelled = distance_travelled+self.speed
	if path.size() > 0:
		var target = global_position.direction_to(path[0])
		velocity = move_and_slide(target * self.speed) * delta
		var path_distance = global_position.distance_to(path[0])
		if global_position.distance_to(path[0]) <= 16:
			path.remove(0)
	
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
	return distance_travelled

func take_damage(damage):
	health = health-damage
	if health <= 0:
		game_scene.current_gold = game_scene.current_gold+self.gold_value
		self.queue_free()

func _on_HitDetection_body_entered(body):
	
	if body.type == "bullet":
		var damage = body.damage
		body.free()
		take_damage(damage)
