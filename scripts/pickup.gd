extends Camera3D

@onready var virtual_cursor : TextureRect = %VirtualCursor
@onready var transform_sound = $TransformSound
@onready var pickup_sound = $PickupSound
const ray_cast_dist : float = 30
const rotate_sensitivity : float = 0.01
var curr_moved_object : SelectableObject = null
var is_dragging : bool = false
var is_rotating : bool = false
var virtual_cursor_pos : Vector2 = Vector2.ZERO
var ray_hit_pos : Vector3 = Vector3.ZERO

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	virtual_cursor_pos = get_viewport().get_mouse_position()

func _process(_delta):
	var from_pos = project_ray_origin(virtual_cursor_pos)
	var end_pos = from_pos + project_ray_normal(virtual_cursor_pos) * ray_cast_dist
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from_pos
	ray_query.to = end_pos
	ray_query.collision_mask = 8
	var raycast_result = space.intersect_ray(ray_query)
	virtual_cursor.set_global_position(virtual_cursor_pos)
	if (not(raycast_result.is_empty())) :
		ray_hit_pos = raycast_result["position"]
		if (not(is_dragging)) :
			if (raycast_result["collider"] is SelectableObject) : # a movable object
				curr_moved_object = raycast_result["collider"]
			else :
				curr_moved_object = null

func _physics_process(_delta):
	if (Input.is_action_just_pressed("click") and curr_moved_object != null) :
		pickup_sound.play()
		is_dragging = true
		curr_moved_object.freeze = true
		curr_moved_object.collision_layer = 2
	if (Input.is_action_just_released("right_click")) :
		is_rotating = false
	if (Input.is_action_pressed("click") and is_dragging) :
		if (Input.is_action_just_pressed("transform")) :
			transform_sound.play()
			is_dragging = false
			is_rotating = false
			curr_moved_object.turn_to_shadow()
			curr_moved_object = null
		if (Input.is_action_just_pressed("right_click")) :
			is_rotating = true
		elif (!Input.is_action_pressed("right_click") and curr_moved_object != null) :
			curr_moved_object.global_position = ray_hit_pos
	elif (Input.is_action_just_released("click") and is_dragging) :
		curr_moved_object.freeze = false
		is_dragging = false
		curr_moved_object.collision_layer = 25

func _input(event):
	if event is InputEventMouseMotion : 
		if is_rotating :
			curr_moved_object.rotate(Vector3.RIGHT, event.relative.y * rotate_sensitivity)
			curr_moved_object.rotate(Vector3.UP, event.relative.x * rotate_sensitivity)
		else :
			virtual_cursor_pos += event.relative
	elif event is InputEventMouseButton: 
		if (Input.mouse_mode != Input.MOUSE_MODE_CAPTURED) :
			virtual_cursor_pos = get_viewport().get_mouse_position()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_level_reset_level():
	is_dragging = false
	is_rotating = false
	curr_moved_object = null
