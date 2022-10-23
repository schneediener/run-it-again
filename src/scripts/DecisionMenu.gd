extends PanelContainer


onready var current_text = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/MarginContainer/MarginContainer/TextDialogue
var playing = false
onready var character_scene = get_node("MarginContainer/RootVBox/CharacterHBox/PortraitContainer")
onready var character_sprite = character_scene.get_node("CharacterControl/CharacterSprite")
onready var audio_player = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/AudioStreamPlayer2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	current_text.visible_characters = 0

func _process(delta):
	if Input.is_action_pressed("ig_space"):
		playing = true
#		_on_ButtonNext_pressed()
	if playing:
		current_text.visible_characters += 1
		if current_text.percent_visible < 0.95:
			character_sprite.playing = true
			var pitch_int = randi() % 2
			if pitch_int == 0:
				audio_player.pitch_scale = 0.8
			else:
				audio_player.pitch_scale = 0.4
			audio_player.play()
		else:
			character_sprite.playing = false
			character_sprite.frame = 0


func _on_ButtonNext_pressed():
	current_text.visible = false
	current_text = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/MarginContainer/MarginContainer/TextDialogue2
	current_text.visible = true
