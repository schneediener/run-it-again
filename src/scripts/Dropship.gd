extends Node2D

var drop_point
var speed
var health
var shield
var health_max
var shield_max
var type = "dropship"
var landing = false
var landed = false
var velocity



func _physics_process(delta):
	get_parent().offset += 450 * delta
	
	if get_parent().unit_offset==1.0 and !landing:
		landing = true
	
	if landing \
	and $Dropship.global_position.distance_to($Shadow.global_position) > 2:
		
		velocity = $Dropship.global_position.direction_to($Shadow.global_position) * 180
		velocity = $Dropship.move_and_slide(velocity)
		if $Dropship.scale>Vector2(0.8, 0.8):
			$Dropship.set_scale($Dropship.scale-Vector2(0.005, 0.005))
	elif !landed:
		$Shadow.hide()
		$SpawnTimer.start()
		landed = true



func _on_SpawnTimer_timeout():
	pass
