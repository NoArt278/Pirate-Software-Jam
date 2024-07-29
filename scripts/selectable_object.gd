extends RigidBody3D

class_name SelectableObject

enum OBJECT_TYPE {BOX, SPHERE, PRISM}

var is_shadow : bool = false
var is_combined : bool = false
var is_damaging : bool = false
var self_type : OBJECT_TYPE
var is_trampoline : bool = false
@onready var combine_area = $Area3D
@onready var mesh_instance_3d = $MeshInstance3D

const BOUNCE_SPEED = 12

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
	connect("body_entered", body_collide)

func combine_shapes(body) : 
	if (body is SelectableObject and body != self and not(is_combined) and not(body.is_combined)) :
		var other_body_mesh : MeshInstance3D = body.find_child("MeshInstance3D")
		other_body_mesh.reparent(self)
		other_body_mesh.position = Vector3.ZERO # Center other mesh
		other_body_mesh.global_rotation = Vector3.ZERO
		global_rotation = Vector3.ZERO
		if (body.self_type == OBJECT_TYPE.BOX) :
			mesh_instance_3d.scale = Vector3(1.25, 1.25, 1.25)
			lock_rotation = true
			axis_lock_linear_x = true
			axis_lock_linear_y = true
			axis_lock_linear_z = true
		elif (body.self_type == OBJECT_TYPE.SPHERE) :
			other_body_mesh.scale = Vector3(1.25, 1.25, 1.25)
			if (physics_material_override != null) :
				physics_material_override.bounce = 0.9
				if (body.linear_velocity.length() > linear_velocity.length()) :
					linear_velocity = body.linear_velocity
			else :
				var new_physics_material = PhysicsMaterial.new()
				new_physics_material.bounce = 0.9
				physics_material_override = new_physics_material
			if (self_type == OBJECT_TYPE.BOX) :
				is_trampoline = true
		else : # Prism
			other_body_mesh.scale = Vector3(1.25, 1.25, 1.25)
			is_damaging = true
			if (self_type == OBJECT_TYPE.SPHERE) :
				is_trampoline = false
			if (physics_material_override != null) :
				physics_material_override.friction = 0.5
				if (body.linear_velocity.length() > linear_velocity.length()) :
					linear_velocity = body.linear_velocity
			else :
				var new_physics_material = PhysicsMaterial.new()
				new_physics_material.friction = 0.5
				physics_material_override = new_physics_material
		body.queue_free()
		is_combined = true

func body_collide(body) :
	if (body is SelectableObject and body.is_trampoline) :
		linear_velocity = BOUNCE_SPEED * (global_position - body.global_position).normalized()
