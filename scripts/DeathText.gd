extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


func _on_player_dead():
	visible = true
