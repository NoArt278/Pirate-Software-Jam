extends AnimatableBody3D

class_name Enemy

@onready var body_mesh = $BodyMesh
@onready var hat_mesh = $HatMesh
@onready var collision_shape_3d = $CollisionShape3D
@onready var area_col = $Area3D/CollisionShape3D
const SPEED = 2.0
var direction = 1
var is_dead = false

func _physics_process(delta):
	if (not(is_dead)) :
		global_position.x += SPEED * direction * delta

func _on_area_3d_body_entered(body):
	if (body is SelectableObject and body.is_damaging and not(is_dead)) :
		collision_shape_3d.set_deferred("disabled", true)
		area_col.set_deferred("disabled", true)
		is_dead = true
		var tween = create_tween()
		tween.tween_property(body_mesh, "scale", Vector3(0, 0 ,0), 0.2)
		tween.tween_property(hat_mesh, "position", Vector3(hat_mesh.position.x, 0, hat_mesh.global_position.z), 0.3)
		await tween.finished
		queue_free()
	elif (body is StaticBody3D or (body is AnimatableBody3D and body != self) or (body is SelectableObject)) :
		direction *= -1
