extends KinematicBody2D

var type = "bullet"
var speed = 750
var velocity = Vector2()
var damage = 2

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(_delta):
	position += Vector2(10, 0)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free() 


func _on_Bullet_input_event(_viewport, _event, _shape_idx):
	pass # Replace with function body.
