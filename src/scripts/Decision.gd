extends HBoxContainer

export(String, "Red", "Blue", "Green") var icon_colour
export (String) var label_text = "This is some example text."

func _ready():
	$Choice1.text = label_text
	match icon_colour:
		"Red":
			$Icon.texture_normal = load("res://src/assets/images/red_icon.png")
		"Blue":
			$Icon.texture_normal = load("res://src/assets/images/blue_icon.png")
		"Green":
			$Icon.texture_normal = load("res://src/assets/images/green_icon.png")
