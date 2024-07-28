extends SelectableObject

func _ready():
	freeze = false
	is_damaging = true

func turn_to_shadow():
	super()
	freeze = false
