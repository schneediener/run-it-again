extends "res://src/scripts/TowersGeneral.gd"

var tower_type = "MissileT1"
var upgrade_path = null
var buy_value = 150
var upgrade_value = null
var sell_value = 150

var Missile = load("res://homing/Missile.tscn")

var delay = 0.5

export var rotation_speed = PI
export var cooldown = 1.5


var target = null
var can_shoot = true

func shoot():
	if can_shoot:
		var m = Missile.instance()
		get_parent().add_child(m)
		m.start($FacingDirection/Muzzle.global_transform, target)
		flash()
		can_shoot = false
		$FacingDirection.hide()
		yield(get_tree().create_timer(cooldown), "timeout")
		$FacingDirection.show()
		yield(get_tree().create_timer(delay), "timeout")
		can_shoot = true

func flash():
	$FacingDirection/Flash.show()
	yield(get_tree().create_timer(0.1), "timeout")
	$FacingDirection/Flash.hide()
	
func find_target():
	var units = $Range.get_overlapping_bodies()
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit
		target = closest
	else:
		target = null
			
func _process(delta):
	if !built:
		return
	if !target:
		find_target()
	if is_instance_valid(target):
		$FacingDirection.look_at(target.global_position)
		shoot()

func _on_Range_body_exited(body):
	if body == target:
		target = null
