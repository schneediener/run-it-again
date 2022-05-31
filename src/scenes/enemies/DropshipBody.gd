extends KinematicBody2D

var type = "enemy"
var subtype = "dropship"
onready var game_scene = get_node("/root/SceneHandler").game_scene

func take_damage(damage, slow):
	var dead
	var new_gold

	get_parent().health = get_parent().health-damage
	get_parent().get_node("HealthBar").value = get_parent().health
	
	if get_parent().health <= 0 and !dead:
		dead = true
		new_gold = game_scene.map_node.income_per_kill*get_parent().gold_multi
		game_scene.current_gold = game_scene.current_gold+new_gold
		print(new_gold)
		get_parent().queue_free()

func get_health():
	return get_parent().health
