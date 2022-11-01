extends PanelContainer

var next_scenario
var last_scenario
onready var game_scene = get_node("/root/SceneHandler").game_scene

func _ready():
	match last_scenario:
		null:
			next_scenario = "intro"
		"intro":
			next_scenario = "approach"
		"approach":
			next_scenario = "entry"
		"entry":
			next_scenario = "attack_decision"
		"attack_decision":
			next_scenario = "end"

func _process(delta):
	$MarginContainer/Control/Label.text = "0:" + str($Timer.time_left)

func _on_Timer_timeout():
	game_scene.dialogue_menu.show()
	game_scene.dialogue_menu.playing = true
