extends Node2D
var freeze_active = true
var max_slow = -0.18

func _process(delta):
	var curr_bodies = $Area2D.get_overlapping_bodies()
	
	if freeze_active:
		for body in curr_bodies:
			var distance_to = body.global_position.distance_to($Area2D/CollisionShape2D.global_position)
			
			var factor = $Area2D/CollisionShape2D.shape.radius/distance_to
			var total_slow = factor*max_slow
			var unique_id = self.get_instance_id()
			if !body.effect_dict.has(unique_id):
				body.effect_dict[unique_id] = total_slow
			elif body.effect_dict[unique_id] != total_slow:
				body.effect_dict[unique_id] = total_slow
				#hmmmmmmm7
func expire_bubble():
	var curr_bodies = $Area2D.get_overlapping_bodies()
	for body in curr_bodies:
		body.effect_dict.erase(self.get_instance_id())
	freeze_active = false
	self.queue_free()
func _on_Timer_timeout():
	expire_bubble()


func _on_Area2D_body_exited(body):
	if body.effect_dict.has(self.get_instance_id()):
		body.effect_dict.erase(self.get_instance_id())
