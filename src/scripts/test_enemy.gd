extends KinematicBody2D

var speed = 400
var velocity = Vector2()
var path = PoolVector2Array()

func _ready():
	print(global_position)
	
func _physics_process(delta):
	if path.size() > 0:
		var target = global_position.direction_to(path[0])
		velocity = move_and_slide(target * speed) * delta
		if global_position.distance_to(path[0]) <= 16:
			path.remove(0)
