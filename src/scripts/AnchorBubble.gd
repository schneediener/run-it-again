extends Node2D
var freeze_active = true

func _process(delta):
	var curr_bodies = $Area2D.get_overlapping_bodies()
	if freeze_active:
		for body in curr_bodies:
			body.time_freeze = true
func expire_bubble():
	var curr_bodies = $Area2D.get_overlapping_bodies()
	for body in curr_bodies:
		body.time_freeze = false
	freeze_active = false
	self.queue_free()
func _on_Timer_timeout():
	expire_bubble()
