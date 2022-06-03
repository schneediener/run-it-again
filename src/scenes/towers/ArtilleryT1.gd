extends "res://src/scripts/TowersGeneral.gd"

var tower_type = "ArtilleryT1"
var weapon_type = "shell"
var upgrade_path = load("res://src/scenes/towers/CannonT2.tscn")
var buy_value = 250
var muzzle_count = 1
var upgrade_value = 450
var sell_value = 150
var damage = 5
var recoil = 0
onready var recoil_timer = $FacingDirection/TurretSprite/TurretSprite/Timer

func _ready():
	built = true
	recoil_timer.wait_time = $FiringRate.wait_time / 4

func _physics_process(delta):
	if recoil == 1:
		if $FacingDirection/TurretSprite/TurretSprite.position.y > 0:
			$FacingDirection/TurretSprite/TurretSprite.position.y -= 0.6
	elif recoil == 2:
		if $FacingDirection/TurretSprite/TurretSprite.position.y < 25:
			$FacingDirection/TurretSprite/TurretSprite.position.y += 0.2


func _on_Timer_timeout():
	match recoil:
		1:
			recoil = 2
			recoil_timer.wait_time = recoil_timer.wait_time * 3
			recoil_timer.start()
		2:
			recoil = 0
			recoil_timer.wait_time = $FiringRate.wait_time / 4
			recoil_timer.stop()
