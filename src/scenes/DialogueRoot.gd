extends Control

onready var current_text = $TextDialogue
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func _process(delta):
	current_text.visible_characters += 1
	if current_text.percent_visible < 0.95:
		$CharacterBorder/CharacterDialogue.playing = true
		var pitch_int = randi() % 2
		if pitch_int == 0:
			$AudioStreamPlayer2D.pitch_scale = 0.8
		else:
			$AudioStreamPlayer2D.pitch_scale = 0.4
		$AudioStreamPlayer2D.play()
	else:
		$CharacterBorder/CharacterDialogue.playing = false
		$CharacterBorder/CharacterDialogue.frame = 0


func _on_ButtonNext_pressed():
	current_text.visible = false
	current_text = $TextDialogue2
	current_text.visible = true
