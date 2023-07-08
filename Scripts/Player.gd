extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

# bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interaction = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/hand
@onready var gun_anim = $Head/Camera3D/Sniper/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Sniper/RayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var picked_object
var pull_power = 4

func pick_object():
	var colider = interaction.get_collider()
	if colider != null and colider is RigidBody3D:
		print("colided")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		
	if event.is_action_pressed("ui_cancel"):
		$PauseMenu.pause()
		
	if event.is_action_pressed("Interact"):
		pick_object()


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0 #move_toward(velocity.x, 0, SPEED)
		velocity.z = 0.0 #move_toward(velocity.z, 0, SPEED)
		
	# Gun controls
	if Input.is_action_pressed("Shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			
			# instantiate bullet based on raycast pos on gun barrel
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			

	move_and_slide()
