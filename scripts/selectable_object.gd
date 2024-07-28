extends RigidBody3D

class_name SelectableObject

var is_shadow : bool = false
var is_combined : bool = false
var is_damaging : bool = false
@onready var combine_area = $Area3D

func turn_to_shadow() :
	is_shadow = true
	var tween = create_tween()
	global_position.z += 1
	var currPos = global_position
	tween.tween_property(self, "global_position", Vector3(global_position.x, global_position.y, -4), 1)
	tween.tween_property(self, "global_position", currPos, 1)
	var curr_anim_player : AnimationPlayer = find_child("AnimationPlayer")
	curr_anim_player.play("turn_to_shadow")
	axis_lock_linear_z = true
	combine_area.connect("body_entered", combine_shapes)

func combine_shapes(body) : 
	if (body is SelectableObject and body != self and not(is_combined)) :
		var other_body_mesh : MeshInstance3D = body.find_child("MeshInstance3D")
		other_body_mesh.reparent(self)
		other_body_mesh.position = Vector3.ZERO # Center other mesh
		other_body_mesh.scale = Vector3(1.25, 1.25, 1.25)
		other_body_mesh.rotation = Vector3.ZERO
		if (body.name.contains("Box")) :
			freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
			freeze = true
		elif (body.name.contains("Sphere")) :
			var new_physics_material = PhysicsMaterial.new()
			new_physics_material.bounce = 0.9
			physics_material_override = new_physics_material
		else : # Prism
			is_damaging = true
		body.queue_free()
		is_combined = true
