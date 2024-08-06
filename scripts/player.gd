extends CharacterBody3D


const SPEED = 4
const JUMP_VELOCITY = 4.5
const BOUNCE_SPEED = 10
const PUSH_FORCE = 5
var can_jump = true
var is_bouncing = false
var can_move = true
var init_z_pos
signal dead
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var bounce_timer : Timer = $BounceTimer
@onready var mesh_instance_3d : MeshInstance3D = $MeshInstance3D
@onready var death_sound : AudioStreamPlayer = $DeathSound
@onready var jump_sound : AudioStreamPlayer = $JumpSound
@onready var bounce_sound = $BounceSound

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	init_z_pos = global_position.z

func _physics_process(delta):
	if is_on_ceiling() :
		print("ceiling")
	# Add the gravity.
	if not is_on_floor():
		if (coyote_timer.is_stopped() and can_jump) :
			coyote_timer.start()
		velocity.y -= gravity * delta
	elif (not(is_bouncing)) :
		can_jump = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false
		jump_sound.play()

	var input_dir = Input.get_axis("move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		if (is_bouncing) :
			velocity.x += direction.x * SPEED * delta
			velocity.z += direction.z * SPEED * delta
		else :
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if (collider is SelectableObject) :
			collider.apply_force(col.get_normal() * -PUSH_FORCE)
			if (collider.is_shadow and collider.is_trampoline) :
				bounce_sound.play()
				velocity = BOUNCE_SPEED * (global_position - collider.global_position).normalized()
				is_bouncing = true
				can_jump = false
				bounce_timer.start()
	if (can_move) :
		move_and_slide()

func _on_coyote_timer_timeout():
	can_jump = false

func _on_bounce_timer_timeout():
	is_bouncing = false


func _on_area_3d_body_entered(body):
	if (body is Enemy) :
		can_move = false
		death_sound.play()
		var tween = create_tween()
		tween.tween_property(mesh_instance_3d, "scale", Vector3.ZERO, 1)
		await tween.finished
		dead.emit()
		queue_free()
