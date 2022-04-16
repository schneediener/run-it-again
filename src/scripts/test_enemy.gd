extends KinematicBody2D

var speed = 400
var velocity = Vector2()
var path = PoolVector2Array()
var distance_travelled = 0
var health = 5

func _ready():
	print(global_position)
	
func _physics_process(delta):
	distance_travelled = distance_travelled+speed
	if path.size() > 0:
		var target = global_position.direction_to(path[0])
		velocity = move_and_slide(target * speed) * delta
		var path_distance = global_position.distance_to(path[0])
		if global_position.distance_to(path[0]) <= 16:
			path.remove(0)
	#print (distance_travelled)

func get_distance():
	return distance_travelled

func take_damage(damage):
	health = health-damage
	if health <= 0:
		self.queue_free()
