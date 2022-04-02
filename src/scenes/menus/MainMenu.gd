extends Control




func _on_NewGameSean_pressed():
	self.queue_free()
	get_tree().change_scene("res://src/scenes/levels/SeanMap.tscn")


func _on_NewGameTest_pressed():
	self.queue_free()
	get_tree().change_scene("res://src/scenes/levels/level.tscn")
