extends Camera3D

@onready var ray_cast_3d : RayCast3D = $RayCast3D
const ray_cast_dist : float = 30
var curr_moved_object : RigidBody3D = null
var is_dragging : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ray_cast_3d.target_position = get_viewport().get_camera_3d().project_ray_origin(get_viewport().get_mouse_position()) + get_viewport().get_camera_3d().project_ray_normal(get_viewport().get_mouse_position()) * ray_cast_dist
	if (ray_cast_3d.is_colliding() and not(is_dragging)) :
		if (ray_cast_3d.get_collider() is RigidBody3D) : # a movable object
			curr_moved_object = ray_cast_3d.get_collider()
		else :
			curr_moved_object = null

func _physics_process(delta):
	if (Input.is_action_just_pressed("click") and curr_moved_object != null) :
		is_dragging = true
		curr_moved_object.freeze = true
		curr_moved_object.collision_layer = 2
	if (Input.is_action_pressed("click") and is_dragging) :
		var new_position : Vector3 = ray_cast_3d.get_collision_point()
		curr_moved_object.global_position = new_position
	elif (Input.is_action_just_released("click") and curr_moved_object != null) :
		curr_moved_object.freeze = false
		is_dragging = false
		curr_moved_object.collision_layer = 1
