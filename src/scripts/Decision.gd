extends HBoxContainer

export(String, "Red", "Blue", "Green") var icon_colour
export (String) var label_text = "This is some example text."
var highlight
var pressed
onready var font = get_node("Choice1").get("custom_fonts/font")

func _ready():
	print ($Choice1.modulate)
	$Choice1.text = label_text
	match icon_colour:
		"Red":
			$Icon.texture_normal = load("res://src/assets/images/red_icon.png")
		"Blue":
			$Icon.texture_normal = load("res://src/assets/images/blue_icon.png")
		"Green":
			$Icon.texture_normal = load("res://src/assets/images/green_icon.png")

func _process(delta):
	match highlight:
		true:
			if !pressed:
#				font.outline_size = 0
				$Choice1.modulate = Color(0.89,0.91,0.19,1)
			else:
				$Choice1.modulate = Color(0.76,0.78,0.06,1)
			
		false:
#			font.outline_size = 1
			$Choice1.modulate = Color(1,1,1,1)

func _on_Button_mouse_entered():
	highlight = true

func _on_Button_mouse_exited():
	highlight = false

func _on_Button_button_down():
	pressed = true

func _on_Button_button_up():
	pressed = false
