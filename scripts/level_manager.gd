extends Node

var curr_level_number : int = 1
var curr_level_resource : PackedScene
var level_instance : Node
var curr_finish
const last_level : int = 10

signal reset_level

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(curr_level_number)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		restart_level()

func load_level(level_num: int) :
	if (level_instance != null) :
		level_instance.queue_free()
	print("res://scenes/levels/level_" + str(level_num) + ".tscn")
	curr_level_resource = load("res://scenes/levels/level_" + str(level_num) + ".tscn")
	level_instance = curr_level_resource.instantiate()
	add_child(level_instance)
	curr_finish = level_instance.find_child("Finish")
	curr_finish.connect("level_finished", load_next_level)

func load_next_level():
	curr_level_number += 1
	load_level(curr_level_number)

func restart_level() :
	reset_level.emit()
	load_level(curr_level_number)
