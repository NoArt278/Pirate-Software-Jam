extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.7
var can_jump = true
var init_z_pos
@onready var coyote_timer = $CoyoteTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	init_z_pos = global_position.z

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if (coyote_timer.is_stopped() and can_jump) :
			coyote_timer.start()
		velocity.y -= gravity * delta
	else :
		can_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = JUMP_VELOCITY
		can_jump = false

	var input_dir = Input.get_axis("move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_coyote_timer_timeout():
	print("time out")
	can_jump = false
