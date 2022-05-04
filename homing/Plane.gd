extends KinematicBody2D

export var speed = 300
export var turn_rate = 0.025

var velocity = Vector2.ZERO
var rotation_dir = 0
var shadow_offset = Vector2(-25, 50)

func get_input():
	rotation_dir = 0
	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1
		
func _physics_process(delta):
	get_input()
	rotation += rotation_dir * turn_rate
	velocity = transform.x * speed
	velocity = move_and_slide(velocity)
	$Shadow.global_position = global_position + shadow_offset
