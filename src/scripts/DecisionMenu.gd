extends PanelContainer


onready var current_text = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/MarginContainer/MarginContainer/TextDialogue
var playing = false
onready var character_scene = get_node("MarginContainer/RootVBox/CharacterHBox/PortraitContainer")
onready var character_sprite = character_scene.get_node("CharacterControl/CharacterSprite")
onready var audio_player = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/AudioStreamPlayer2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var text_a1 = "That's it. That's the target."
var text_a2 = "Don't get distracted. This timeline has nothing else for us."
var text_a3 = "We're not here to save the day."
var text_a4 = "Get into the basement, breach the bunker, take the tech, and get out."
var text_a5 = "What happens after that.. ain't our problem."
var array_a = [text_a1, text_a2, text_a3, text_a4, text_a5]


var text_b1 = "We are about to arrive on-site, commander."
var text_b2 = "Permission to speak candidly, sir?"
var text_b3 = "... Last tactical that broke into that building never did report back. Not even screams."
var text_b4 = "The second we hit the office perimeter..."
var text_b5 = "Situation could get fucked up beyond recognition, sir."
var text_b6 = "Just wanted to let you know, since.. you're from.. 'out of town' and all."
var array_b = [text_b1, text_b2, text_b3, text_b4, text_b5, text_b6]


var text_c1 = "OK.. Reporting perimeter entry, currently breaching entrance to the building. Locked up tight."
var text_c2 = "[i]Quit smiling, private! Get those eyes on the horizon before I turn you into a stain on the God damned wall![/i]"
var text_c3 = "Entrance breached. Signs of previous.. casualties, but no contact with the enemy. Repeat, no contact."
var text_c4 = "[i]*Crack* Shit- No, all clear! all clear - just stepped on.. some bones?.. Ar-... Are those fucking *teeth*?[/i]"
var text_c5 = "[i]Private, I told you eyes up. Dead ain't gonna kill you.[/i]"
var text_c6 = "[i]Roger that, sir. Ain't the dead we should be worried about, got plent-- [/i]CONTACT, ON OUR SIX. ENTRANCEWAY."
var array_c = [text_c1, text_c2, text_c3, text_c4, text_c5, text_c6]


var text_d1 = "[i]*The sputtering of remaining gun fire, slowly dying out.[/i]*"
var text_d2 = "Command, this is Alpha. Report sustained contact with 5 targets to our rear."
var text_d3 = "[i]Man down! Call for evac![/i]"
var text_d4 = "Break. We have sustained casualities but will continue as planned."
var text_d5 = "[i]What?! The fuck we will! I'm not dying down here--[/i]"
var text_d6 = "[i]*A solitary gunshot*[/i]"
var text_d7 = "...ETA 2 minutes to the objective. May lose radio contact underground. Alpha out."
var array_d = [text_d1, text_d2, text_d3, text_d4, text_d5, text_d6, text_d7]
var decision_array = ["What will you do?", "decision_time"]
var array_array = [array_a, array_b, array_c, array_d, decision_array]

var current_array = array_a
var curr_max = current_array.size()
var curr_int = 0
var curr_array_int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_text.bbcode_text = current_array[0]
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
	curr_int += 1
	if curr_int == curr_max:
		curr_array_int += 1
		current_array = array_array[curr_array_int]
		curr_int = 0
		curr_max = current_array.size()
	
	if current_array[1] == "decision_time":
		$MarginContainer/RootVBox/DecisionMargin.show()
	current_text.visible_characters = 0
	current_text.bbcode_text = current_array[curr_int]

