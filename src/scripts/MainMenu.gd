extends Control


#I don't love this "If X != OK" working for changing scenes. 
#it isn't natural, but, it works to get rid of warnings about unused values

func _on_NewGameSean_pressed():
	self.queue_free()
	#get_tree().change_scene("res://src/scenes/levels/SeanMap.tscn")
	if get_tree().change_scene("res://src/scenes/levels/SeanMap.tscn") != OK:
		print("scene change failed")


func _on_NewGameTest_pressed():
	self.queue_free()
#	get_tree().change_scene("res://src/scenes/levels/level.tscn")
	if get_tree().change_scene("res://src/scenes/levels/level.tscn") != OK:
		print("scene change failed")
