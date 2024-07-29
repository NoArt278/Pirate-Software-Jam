extends SelectableObject

func _ready():
	freeze = false
	self_type = OBJECT_TYPE.SPHERE
	is_trampoline = true

func turn_to_shadow():
	super()
	freeze = false
