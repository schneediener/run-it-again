extends "res://src/scripts/LauncherGeneral.gd"

var tower_type = "LauncherT2"
var weapon_type = "missile"
var upgrade_path = null
var buy_value = null
var upgrade_value = null
var sell_value = 400
var damage = 10
var muzzle_count = 2

var delay = 0.5

export var rotation_speed = PI
export var cooldown = 1.5
