extends "res://src/scripts/TowersGeneral.gd"

var Missile = load("res://src/scenes/towers/Missile.tscn")

var delay = 0.5

export var rotation_speed = PI
export var cooldown = 1.5


var target = null
var target2 = null
var can_shoot = true

func shoot():
	find_target()
	yield(get_tree().create_timer(0.1), "timeout")
	
	if can_shoot:
		var m = Missile.instance()
		get_parent().add_child(m)
		m.start($FacingDirection/Muzzle.global_transform, target, self.tower_type)
		flash(1)
		if self.tower_type=="LauncherT2":
			var m2 = Missile.instance()
			get_parent().add_child(m2)
			m2.start($FacingDirection/Muzzle2.global_transform, target2, self.tower_type)
			flash(2)
			
		can_shoot = false
		
		if self.tower_type=="LauncherT1":
			$FacingDirection.hide()
			yield(get_tree().create_timer(cooldown), "timeout")
			$FacingDirection.show()
			yield(get_tree().create_timer(delay), "timeout")
		elif self.tower_type=="LauncherT2":
			$FacingDirection/TurretSprite.set_region_rect(Rect2(1345, 576, 64, 64))
			yield(get_tree().create_timer(cooldown), "timeout")
			$FacingDirection/TurretSprite.set_region_rect(Rect2(1345, 512, 64, 64))
			yield(get_tree().create_timer(delay), "timeout")
		can_shoot = true

func flash(muzzle):
	if muzzle==1:
		$FacingDirection/Flash.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$FacingDirection/Flash.hide()
	else:
		$FacingDirection/Flash2.show()
		yield(get_tree().create_timer(0.1), "timeout")
		$FacingDirection/Flash2.hide()
func find_target():
	var closest
	var closest2
	var units = $Range.get_overlapping_bodies()
	for unit in units:
		if unit.type!="enemy":
			units.erase(unit)
	if units.size() == 0:
		target = null
		target2 = null
		return

	if !target:
		target = units[0]

	if !target2:
		if units.size() == 1:
			target2 = units[0]
		else:
			target2 = units[1]

func _process(delta):
	if !built:
		return
	if !target or !target2:
		find_target()
	if is_instance_valid(target):
		$FacingDirection.look_at(target.global_position)
		shoot()

func _on_Range_body_exited(body):
	if body == target:
		target = null
	if body == target2:
		target2 = null
