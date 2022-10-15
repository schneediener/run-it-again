extends TowersGeneral

var tower_type = "LauncherT1"
var weapon_type = "missile"
var upgrade_path = load("res://src/scenes/towers/LauncherT2.tscn")
var buy_value = 150
var upgrade_value = 250
var sell_value = 150
var damage = 10
var muzzle_count = 1

var delay = 0.5

export var rotation_speed = PI
export var cooldown = 1.5
