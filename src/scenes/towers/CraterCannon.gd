extends StaticBody2D #"res://src/scripts/TowersGeneral.gd"

var tower_type = "CannonT1"
var weapon_type = "cannon"
var upgrade_path = load("res://src/scenes/towers/CannonT2.tscn")
var buy_value = 150
var muzzle_count = 1
var upgrade_value = 450
var sell_value = 150
var damage = 3
var cooldown = 0


func _ready():
	$FacingDirection/LaserBeam2D.is_casting = false


func _on_LaserBeam2D_enemy_hit(enemy_hit):
	enemy_hit.take_damage(1, true)

func _process(delta):
	if $FacingDirection/LaserBeam2D.is_casting:
		cooldown += 2.5
		$FacingDirection.look_at(get_global_mouse_position())
		if cooldown >= 100:
			$FacingDirection/LaserBeam2D.is_casting = false
			cooldown = 0
	if Input.is_action_just_pressed("ui_cancel"):
		if $FacingDirection/LaserBeam2D.is_casting:
			$FacingDirection/LaserBeam2D.is_casting = false
			cooldown = 0
		else:
			$FacingDirection/LaserBeam2D.is_casting = true
			$FacingDirection.look_at(get_global_mouse_position())
