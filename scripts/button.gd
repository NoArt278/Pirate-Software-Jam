extends Area3D

@onready var target_obj
var target : Array
var is_activated : bool = false
@onready var animation_player = $AnimationPlayer

func _ready():
	target_obj = find_child("TargetObj")
	target = target_obj.get_children()

func _on_body_entered(body):
	if (body.name == "Player") and not(is_activated) :
		is_activated = true
		animation_player.play("press")
		for t in target :
			t.find_child("AnimationPlayer").play("interacted")
