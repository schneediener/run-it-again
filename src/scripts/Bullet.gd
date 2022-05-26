extends KinematicBody2D

var type = "bullet"
var speed = 1750
var velocity = Vector2()
var target_velocity = Vector2()
var target
var direction
var orig_tower
var damage
var slow

func start(inc_muzzle, inc_target, inc_orig_tower):
	
	self.global_position = inc_muzzle
	
	orig_tower = inc_orig_tower
	damage = orig_tower.damage
	target = inc_target
	look_at(target.global_position)

func _physics_process(delta):
	if is_instance_valid(target):
		look_at(target.position)
		var direction = global_position.direction_to(target.global_position)
		target_velocity = target_velocity.move_toward(direction * speed, speed * 100)
		move_and_slide(target_velocity)
	else:
		if target_velocity:
			move_and_slide(target_velocity)
		else:
			free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 


func _on_Bullet_input_event(_viewport, _event, _shape_idx):
	pass # Replace with function body.
