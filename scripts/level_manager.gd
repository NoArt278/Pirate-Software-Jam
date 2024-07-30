extends Node

var curr_level_number : int = 0
var curr_level_resource : PackedScene
var level_instance : Node
var curr_finish
@onready var finish_sound = $FinishSound
const last_level : int = 7

signal reset_level

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level(curr_level_number)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		restart_level()

func load_start() :
	if (level_instance != null) :
		level_instance.queue_free()
	curr_level_resource = load("res://scenes/levels/menu.tscn")
	level_instance = curr_level_resource.instantiate()
	add_child(level_instance)
		
func load_level(level_num: int) :
	if (level_instance != null) :
		level_instance.queue_free()
	if (level_num > last_level) :
		curr_level_resource = load("res://scenes/levels/end.tscn")
		curr_level_number = -1
	elif (level_num == 0) :
		curr_level_resource = load("res://scenes/levels/menu.tscn")
	else :
		curr_level_resource = load("res://scenes/levels/level_" + str(level_num) + ".tscn")
	level_instance = curr_level_resource.instantiate()
	add_child(level_instance)
	curr_finish = level_instance.find_child("Finish")
	if (curr_finish != null) :
		curr_finish.connect("level_finished", load_next_level)

func load_next_level():
	finish_sound.play()
	curr_level_number += 1
	load_level(curr_level_number)

func restart_level() :
	reset_level.emit()
	load_level(curr_level_number)
