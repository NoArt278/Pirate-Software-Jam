extends SelectableObject

func _ready():
	self_type = OBJECT_TYPE.BOX
	freeze = false

func turn_to_shadow():
	super()
	lock_rotation = true
	axis_lock_linear_x = true
	axis_lock_linear_y = true
	axis_lock_linear_z = true
	freeze = false
