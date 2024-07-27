extends Area3D

@onready var target_obj = $TargetObj
var target : Array
@onready var animation_player = $AnimationPlayer

func _ready():
	target = target_obj.get_children()

func _process(delta):
	pass


func _on_body_entered(body):
	if (body.name == "Player") :
		animation_player.play("press")
