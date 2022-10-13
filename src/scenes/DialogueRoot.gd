extends Control

onready var current_text = $TextDialogue
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.


func _process(delta):
	current_text.visible_characters += 1


func _on_ButtonNext_pressed():
	current_text.visible = false
	current_text = $TextDialogue2
	current_text.visible = true
