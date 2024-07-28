extends SelectableObject

func _ready():
	freeze = false

func turn_to_shadow():
	super()
	freeze = false
