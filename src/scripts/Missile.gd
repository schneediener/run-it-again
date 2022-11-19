extends "res://src/scripts/temporal_engine.gd"

export var orig_speed = 450
export var orig_steer_force = 50.0

var speed = 559
var steer_force = 50.0

var type = "missile"

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var damage
var orig_tower
var exploded = false

func start(inc_transform, inc_target, inc_orig_tower):
	global_transform = inc_transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = inc_target
	orig_tower = inc_orig_tower
	
	if orig_tower.tower_type == "LauncherT2":
		steer_force = 300.0
	
	damage = orig_tower.damage
	
func seek():
	var steer = Vector2.ZERO
	if is_instance_valid(target):
		var desired = (target.global_position - global_position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	speed = orig_speed * temporal_momentum
	steer_force = orig_steer_force * temporal_momentum
	$Particles2D.speed_scale = 1 * temporal_momentum
	$AnimationPlayer.playback_speed = 1 * temporal_momentum
	
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	
func _on_Lifetime_timeout():
	if !exploded:
		exploded = true
		explode()

func explode():
	$BlastRadius.show()
	var units = $BlastRadius.get_overlapping_bodies()
	if units.size() > 0:
		for unit in units:
			if unit.type=="enemy":
				unit.take_damage(damage, false)
	$BlastRadius.hide()
	$Particles2D.emitting = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	


func _on_Area2D_body_entered(body):
	if body==target and !exploded:
		exploded = true
		explode()
