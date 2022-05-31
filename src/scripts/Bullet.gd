extends KinematicBody2D

var type = "bullet"
var speed = 1750
var velocity = Vector2()
var target_velocity = Vector2()
var target

var orig_tower
var damage
var slow
var target_position

func start(inc_muzzle, inc_target, inc_orig_tower):
	
	self.global_position = inc_muzzle
	
	orig_tower = inc_orig_tower
	damage = orig_tower.damage
	target = inc_target
	target_position = inc_target.get_global_position()
	look_at(target_position)

func _physics_process(_delta):
	if is_instance_valid(target):
		target_position = target.get_global_position()
		look_at(target_position)
		var direction = global_position.direction_to(target_position)
		target_velocity = target_velocity.move_toward(direction * speed, speed * 100)
		velocity = move_and_slide(target_velocity)
	else:
		if target_velocity:
			var direction = global_position.direction_to(target_position)
			target_velocity = target_velocity.move_toward(direction * speed, speed * 100)
			velocity = move_and_slide(target_velocity)
			var distance = global_position.distance_to(target_position)
			if distance <= 20:
				queue_free()
		else:
			free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 


func _on_Bullet_input_event(_viewport, _event, _shape_idx):
	pass # Replace with function body.
