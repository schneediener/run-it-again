extends Control



func _ready():
	self.connect("on_Upgrade_pressed", get_parent(), "_on_Upgrade_pressed")
	self.connect("on_Sell_pressed", get_parent(), "_on_Sell_pressed")
	self.connect("on_TargetOption_item_selected", get_parent(), "_on_TargetOption_item_selected")

func _on_Upgrade_pressed():
	pass # Replace with function body.


func _on_Sell_pressed():
	pass # Replace with function body.


func _on_TargetOption_item_selected(index):
	pass # Replace with function body.
