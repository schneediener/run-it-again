extends Area2D
onready var game_scene = get_node("/root/SceneHandler").game_scene

func _on_MissionLocation_body_entered(body):
	if body.type == "infantry":
		if body.tower_type == "Infantry":
			mission_start()

func mission_start():
	game_scene.dialogue_menu.show()
	game_scene.dialogue_menu.playing = true
