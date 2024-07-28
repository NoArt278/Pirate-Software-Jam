extends RigidBody3D

class_name SelectableObject

var is_shadow : bool = false
var is_combined : bool = false

func _ready():
	connect("body_entered", combine_shapes)

func turn_to_shadow() :
	is_shadow = true
	var tween = create_tween()
	global_position.z += 1
	var currPos = global_position
	tween.tween_property(self, "global_position", Vector3(global_position.x, global_position.y, -4), 1)
	tween.tween_property(self, "global_position", currPos, 1)
	var curr_anim_player : AnimationPlayer = find_child("AnimationPlayer")
	curr_anim_player.play("turn_to_shadow")

func combine_shapes() : 
	pass
