extends RigidBody3D

var selectable : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (selectable and Input.is_action_pressed("click")) :
		var mouse_ray_origin = get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position())
		var mouse_ray_normal = get_viewport().get_camera_3d().project_ray_normal(get_viewport().get_mouse_position())
		position = mouse_ray_origin + mouse_ray_normal * 3

func _on_mouse_entered():
	selectable = true

func _on_mouse_exited():
	selectable = false
