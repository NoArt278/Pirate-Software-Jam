extends SelectableObject

func _ready():
	freeze = false
	is_damaging = true
	self_type = OBJECT_TYPE.PRISM

func turn_to_shadow():
	super()
	freeze = false
