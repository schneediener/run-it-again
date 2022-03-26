extends Node2D

onready var nav_2d: Navigation2D = $Navigation2D
onready var character: KinematicBody2D = $TestEnemy
onready var line_2d: Line2D = $Line2D

var end_point = Vector2(480, 1050)


func _ready():
    yield(get_tree(), "idle_frame")
    print(character.global_position)
    var path = nav_2d.get_simple_path(character.global_position, end_point, true)
    print(path)
    character.path = path
    line_2d.points = path
