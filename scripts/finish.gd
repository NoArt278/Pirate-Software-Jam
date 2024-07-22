extends Area3D
signal level_finished

func _on_body_entered(body):
	if (body.name == "Player") :
		level_finished.emit()
