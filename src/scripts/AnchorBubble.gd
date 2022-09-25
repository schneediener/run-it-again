extends Node2D
var freeze_active = true
var max_slow = -0.5

func _process(delta):
	var curr_bodies = $Area2D.get_overlapping_bodies()
	
	if freeze_active:
		for body in curr_bodies:
			var factor = (body.distance_to(self)/self.radius)
			var total_slow = max_slow*factor
			if !body.effect_dict[self.get_instance_id()]:
				body.effect_dict[self.get_instance_id()] = [total_slow]
				#hmmmmmmm
func expire_bubble():
	var curr_bodies = $Area2D.get_overlapping_bodies()
	for body in curr_bodies:
		body.temporal_momentum += body.distance_to(self)/self.radius
	freeze_active = false
	self.queue_free()
func _on_Timer_timeout():
	expire_bubble()
