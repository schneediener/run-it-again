extends StaticBody2D #"res://src/scripts/TowersGeneral.gd"

var tower_type = "CannonT1"
var weapon_type = "cannon"
var upgrade_path = load("res://src/scenes/towers/CannonT2.tscn")
var buy_value = 150
var muzzle_count = 1
var upgrade_value = 450
var sell_value = 150
var damage = 2
var cooldown = 0
var ready = true

onready var laser_firing = false

func _process(delta):
		if Input.is_action_just_pressed("ui_cancel"):
			if self.ready:
				$LaserTimer.start()
				laser_firing = true

func _physics_process(delta):
	$FacingDirection.look_at(get_global_mouse_position())
	if laser_firing:
		do_laser_damage()

func do_laser_damage():
	for enemy in $Range.get_overlapping_bodies():
		if enemy.type == "enemy":
			enemy.take_damage(damage, true)


func _on_LaserTimer_timeout():
	laser_firing = false
	$FiringRate.start()

func _on_FiringRate_timeout():
	self.ready = true

#OLD CODE
#func _ready():
#	$FacingDirection/LaserBeam2D.is_casting = false
#
#
#func _on_LaserBeam2D_enemy_hit(enemy_hit):
#	enemy_hit.take_damage(1, true)
#
#func _process(delta):
#	if $FacingDirection/LaserBeam2D.is_casting:
#		cooldown += 2.5
#		$FacingDirection.look_at(get_global_mouse_position())
#		if cooldown >= 100:
#			$FacingDirection/LaserBeam2D.is_casting = false
#			cooldown = 0
#	if Input.is_action_just_pressed("ui_cancel"):
#		if $FacingDirection/LaserBeam2D.is_casting:
#			$FacingDirection/LaserBeam2D.is_casting = false
#			cooldown = 0
#		else:
#			$FacingDirection/LaserBeam2D.is_casting = true
#			$FacingDirection.look_at(get_global_mouse_position())





