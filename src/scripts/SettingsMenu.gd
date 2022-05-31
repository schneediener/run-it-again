extends Control

onready var fullscreen = $VisualSettings/FullScreenCheck
onready var vsync = $VisualSettings/VSyncCheck
onready var master_sound = $VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
onready var sfx_sound = $VBoxContainer/EffectsVolumeContainer/EffectsVolumeSlider
onready var music_sound = $VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
onready var back = $VBoxContainer/HBoxContainer/BackButton
onready var apply = $VBoxContainer/HBoxContainer/ApplyButton


func _ready():
	vsync.pressed = OS.vsync_enabled
	fullscreen.pressed = OS.window_fullscreen
#	$VBoxContainer/MasterVolumeContainer/MasterVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
#	$VBoxContainer/EffectsVolumeContainer/EffectsVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Effects"))
#	$VBoxContainer/MusicVolumeContainer/MusicVolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))

func _on_MasterVolumeSlider_value_changed(_value):
	pass # Replace with function body.


func _on_EffectsVolumeSlider_value_changed(_value):
	pass # Replace with function body.


func _on_MusicVolumeSlider_value_changed(_value):
	pass # Replace with function body.


func _on_BackButton_pressed():
	queue_free()


func _on_ApplyButton_pressed():
	if vsync.pressed != OS.vsync_enabled:
		OS.vsync_enabled = vsync.pressed
	if fullscreen.pressed != OS.window_fullscreen:
		OS.window_fullscreen = fullscreen.pressed
