extends KinematicBody2D

var speed = 400
var velocity = Vector2()
var path = PoolVector2Array()
var distance_travelled = 0
var health = 10
var max_health = 10
var health_perc

func _ready():
	$HealthBar.value = max_health
	$HealthBar.max_value = max_health
	calculate_health_perc()
#	print(global_position)
	
func _physics_process(delta):
	distance_travelled = distance_travelled+speed
	if path.size() > 0:
		var target = global_position.direction_to(path[0])
		velocity = move_and_slide(target * speed) * delta
		var path_distance = global_position.distance_to(path[0])
		if global_position.distance_to(path[0]) <= 16:
			path.remove(0)
	
	if $HealthBar.value != health:
		$HealthBar.value = health
		calculate_health_perc()
		set_health_tint()
		
	#print (distance_travelled)
func calculate_health_perc():
#	var perc = (health/max_health)*100
	var perc = round((float(health)/max_health)* 100)
	health_perc = perc
func set_health_tint():
	if health_perc <= 80 and health_perc >= 50:
		$HealthBar.tint_progress = Color(0, 255, 0)
	elif health_perc <= 49 and health_perc >= 25:
		$HealthBar.tint_progress = Color(255, 255, 0)
	elif health_perc <=24:
		$HealthBar.tint_progress = Color(255, 0, 0)
	else:
		$HealthBar.tint_progress = null
	
func get_distance():
	return distance_travelled

func take_damage(damage):
	health = health-damage
	if health <= 0:
		self.queue_free()

func _on_HitDetection_body_entered(body):
	
	if body != self:
		take_damage(2)
		body.queue_free()
