extends KinematicBody2D

export var max_speed = 350
export var steer_force = 0.1
export var look_ahead = 100
export var num_rays = 8
var type = "enemy"
var subtype="creep"
# context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

onready var game_scene = get_node("/root/SceneHandler").game_scene
onready var path = game_scene.map_node.get_node("Path2D")
onready var path_follow = path.get_node("PathFollow2D")

func _ready():
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)
	var speed_random = randi() % 2
	if speed_random == 0:
		max_speed += 100

func _physics_process(delta):
	set_interest()
	set_danger()
	choose_direction()
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	velocity = velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = velocity.angle()
	move_and_slide(velocity * 100 * delta)


func set_interest():
	# Set interest in each slot based on world direction
#	if owner and owner.has_method("get_path_direction"):
		var path_direction = get_path_direction(position)
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0.05, (d))
	# If no world path, use default interest
#		else:
#			set_default_interest()

func set_default_interest():
	# Default to moving forward
	for i in num_rays:
		var d = ray_directions[i].rotated(rotation).dot(transform.x)
		interest[i] = max(0, d)

func set_danger():
	# Cast rays to find danger directions
	var space_state = get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(position,
				position + ray_directions[i].rotated(rotation) * look_ahead,
				[self])
		if result:
			var distance_to = look_ahead/((position.distance_to(result.position)+0.1)/2)
			danger[i] = 1
		else: 
			danger[i] = 0.0

func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()

func get_path_direction(pos):
	var offset = path.curve.get_closest_offset(pos)
	path_follow.offset = offset
	return path_follow.transform.x
