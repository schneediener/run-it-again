extends Camera2D

#var threshold = 50
#var step = 10
#onready var viewport_size = get_viewport().size
#
#func _process(delta):
#	var local_mouse_pos = get_local_mouse_position()
#	if local_mouse_pos.x < threshold:
#		position.x -= step
#	elif local_mouse_pos.x > viewport_size.x:
#		position.x += step
