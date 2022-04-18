extends "res://src/scripts/TowersGeneral.gd"
signal click_time

func _ready():
	var secondary = get_node("../../..")
	print(secondary)
	connect("input_event", secondary , "_on_SelectArea_input_event")
	print(is_connected("input_event", secondary, "_on_SelectArea_input_event"))



func _on_SelectArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("click_time")
		print("signal emitted")
	pass
