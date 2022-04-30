extends Area2D

export var speed = 450
export var steer_force = 50.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var damage = 10

func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target
	
func seek():
	var steer = Vector2.ZERO
	if is_instance_valid(target):
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta
	
func _on_Missile_body_entered(body):
	if body.get("type"):
		if body.type=="enemy":
			explode()

func _on_Lifetime_timeout():
	explode()

func explode():
	$Particles2D.emitting = false
	set_physics_process(false)
	velocity = Vector2.ZERO
	$AnimationPlayer.play("explode")
	$BlastRadius.show()
	var units = get_overlapping_bodies()
	if units.size() > 0:
		for unit in units:
			if unit.type=="enemy":
				unit.take_damage(damage)
	yield($AnimationPlayer, "animation_finished")
	queue_free()
	
