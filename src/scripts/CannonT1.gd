extends TowersGeneral

var tower_type = "CannonT1"
var weapon_type = "cannon"
var upgrade_path = load("res://src/scenes/towers/CannonT2.tscn")
var buy_value = 150
var muzzle_count = 1
var upgrade_value = 450
var sell_value = 150
var damage = 4.5

func _process(delta):
	audio_player = $AudioStreamPlayer2D
