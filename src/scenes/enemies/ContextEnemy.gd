extends "res://src/scripts/test_enemies_general.gd"

var speed = 310
var max_health = 10
var gold_multi = 1

var all_raycasts = [$RayCast2D, $RayCast2D2, $RayCast2D3]

export var max_speed = 350
export var steer_force = 0.1
export var look_ahead = 100
export var num_rays = 3

# context array
var ray_directions = []
var interest = [all_raycasts]
var danger = []
var colliders

var chosen_dir = Vector2.ZERO
var context_velocity = Vector2.ZERO
var acceleration = Vector2.ZERO

func _ready():
	
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)

func _physics_process(delta):
	self.speed = 0
	set_interest()
	set_danger()
	choose_direction()
	var desired_velocity = chosen_dir.rotated(rotation) * max_speed
	context_velocity = context_velocity.linear_interpolate(desired_velocity, steer_force)
	rotation = context_velocity.angle()
	move_and_collide(context_velocity * delta)
#	colliders = $Forward.get_collider()


func set_interest():
	# Set interest in each slot based on world direction
	if owner and owner.has_method("get_path_direction"):
		var path_direction = owner.get_path_direction(position)
		for i in num_rays:
			var d = ray_directions[i].rotated(rotation).dot(path_direction)
			interest[i] = max(0, d)
	# If no world path, use default interest
	else:
		set_default_interest()

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
		danger[i] = 1.0 if result else 0.0

func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()

func get_path_direction(pos):
	var offset = path.curve.get_closest_offset(pos)
	path.offset = offset
	return path.transform.x
