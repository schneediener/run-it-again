extends PanelContainer


onready var current_text = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/MarginContainer/MarginContainer/TextDialogue
var playing = false
onready var character_scene = get_node("MarginContainer/RootVBox/CharacterHBox/PortraitContainer")
onready var character_sprite = character_scene.get_node("CharacterControl/CharacterSprite")
onready var character_name = character_scene.get_node("NamePanel/CharacterName")
onready var audio_player = $MarginContainer/RootVBox/CharacterHBox/PanelDialogue/AudioStreamPlayer2D
onready var game_scene = get_node("/root/SceneHandler").game_scene

var text_a1 = "That's it. That's the target."
var text_a2 = "Don't get distracted. This timeline has nothing else for us."
var text_a3 = "We're not here to save the day."
var text_a4 = "Get into the basement, breach the bunker, take the tech, and get out."
var text_a5 = "What happens after that.. ain't our problem."
var array_a = [Color(0,0,0,1), "UNKNOWN", 0.90, text_a1, text_a2, text_a3, text_a4, text_a5]

var text_b1 = "We are about to arrive on-site, commander."
var text_b2 = "Permission to speak candidly, sir?"
var text_b3 = "... Last tactical that broke into that building never did report back. Not even screams."
var text_b4 = "The second we hit the office perimeter..."
var text_b5 = "Situation could get fucked up beyond recognition, sir."
var text_b6 = "Just wanted to let you know, since.. you're from.. 'out of town' and all."
var array_b = [Color(1,0,0,1), "Briggs", 1.1, text_b1, text_b2, text_b3, text_b4, text_b5, text_b6]

var text_c1 = "OK.. Reporting perimeter entry, currently breaching entrance to the building. Locked up tight."
var text_c2 = "[i]Quit smiling, private! Get those eyes on the horizon before I turn you into a stain on the God damned wall![/i]"
var text_c3 = "Entrance breached. Signs of previous.. casualties, but no contact with the enemy. Repeat, no contact."
var text_c4 = "[i]*Crack* Shit- No, all clear! all clear - just stepped on.. some bones?.. Ar-... Are those fucking *teeth*?[/i]"
var text_c5 = "[i]Private, I told you eyes up. Dead ain't gonna kill you.[/i]"
var text_c6 = "[i]Roger that, sir. Ain't the dead we should be worried about, got plent-- [/i]CONTACT, ON OUR SIX. ENTRANCEWAY."
var array_c = [Color(1,0,0,1), "Briggs", 1.1, text_c1, text_c2, text_c3, text_c4, text_c5, text_c6]

var text_d1 = "[i]*The sputtering of remaining gun fire, slowly dying out.[/i]*"
var text_d2 = "Command, this is Alpha 3. I have assumed command. Report sustained contact with 5 targets to our rear."
var text_d3 = "[i]Man down! Briggs is hit! Call for evac![/i]"
var text_d4 = "Break. We have sustained casualities but will continue as planned."
var text_d5 = "[i]What?! The fuck we will! I'm not dying down here--[/i]"
var text_d6 = "[i]*A solitary gunshot*[/i]"
var text_d7 = "...ETA 2 minutes to the objective. May lose radio contact underground. Alpha out."
var array_d = [Color(0,0,0,1), "Alpha 3", 0.8, text_d1, text_d2, text_d3, text_d4, text_d5, text_d6, text_d7]
var decision_array = ["What will you do?", "decision_time"]
var passive = "I've.. failed you."
var determined = "Mission complete. Squadmates lost."
var retreat_1 = "Request backup. Entranceway is blocked. Taking heavy losses. This.. was a mistake."
var retreat_2 = "[i]Don't you fucking let go of that trigger! Don't you fucking let go![/i]"
var retreat_3 = "[i]*static*[/i]"
var retreat_array = [Color(0,0,0,1), "Alpha 3", 0.8, retreat_1, retreat_2, retreat_3]
var array_array = [array_a, array_b, array_c, array_d, decision_array]

var finish_state

var current_array = array_a
var curr_max = current_array.size()
var curr_int = 3
var curr_array_int = 0
var character_pitch = 1
var text_revealed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("decision_buttons"):
			i.connect("pressed", self, "decision_selected", [i])
	current_text.bbcode_text = current_array[3]
	current_text.visible_characters = 0
	character_sprite.modulate = current_array[0]
	character_name.text = current_array[1]
	character_pitch = current_array[2]

func _process(delta):
#	if Input.is_action_pressed("ig_space"):
#		playing = true
#		_on_ButtonNext_pressed()
	if playing:
		if !text_revealed:
			current_text.visible_characters += 1
			text_revealed = true
		else:
			text_revealed = false
		if current_text.percent_visible < 0.95:
			character_sprite.playing = true
			var pitch_int = randi() % 2
			if pitch_int == 0:
				audio_player.pitch_scale = 0.8
				audio_player.pitch_scale = audio_player.pitch_scale * character_pitch
			else:
				audio_player.pitch_scale = 0.4
			audio_player.play()
		else:
			character_sprite.playing = false
			character_sprite.frame = 0
			audio_player.stop()

func decision_selected(decision):
	match decision.get_node("../../").label_text:
		"Retreat at once":
			current_array = retreat_array
			finish_state = "bad"
		"Silent approval":
			current_text.bbcode_text = passive
			finish_state = "bad"
		"Complete the mission at any cost":
			current_text.bbcode_text = determined
			curr_int = 3
			curr_max = current_array.size()
			finish_state = "good"
	trigger_timer()
	$MarginContainer/RootVBox/DecisionMargin.hide()

func trigger_timer():
	game_scene.reset_notification_icon()
	playing = false
	hide()
	

func _on_ButtonNext_pressed():
	match finish_state:
			"bad":
				game_scene.map_node.finish_level("bad")
			"good":
				game_scene.map_node.finish_level("good")
	curr_int += 1
	if curr_int == curr_max:
		trigger_timer()
		curr_array_int += 1
		current_array = array_array[curr_array_int]
		curr_int = 3
		curr_max = current_array.size()
	
	if current_array[1] == "decision_time":
		$MarginContainer/RootVBox/DecisionMargin.show()
		current_text.visible_characters = 100
	current_text.visible_characters = 0
	if current_array == decision_array:
		curr_int = 1
	current_text.bbcode_text = current_array[curr_int]
	if current_array != decision_array:
		character_sprite.modulate = current_array[0]
		character_name.text = current_array[1]
		character_pitch = current_array[2]
