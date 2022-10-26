extends Area2D


func _on_MissionLocation_body_entered(body):
	if body.tower_type == "Infantry":
		
