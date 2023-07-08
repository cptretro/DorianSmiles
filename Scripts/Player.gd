extends CharacterBody3D

var SPEED
const WAlK_SPEED = 4.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

# bullets
var bullet = load("res://Scenes/bullet.tscn")
var instance
#head bob variable
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#FOV variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

#health
var health = 100





@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var interaction = $Head/Camera3D/RayCast3D
@onready var hand = $Head/Camera3D/hand
@onready var gun_anim = $Head/Camera3D/Sniper/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Sniper/RayCast3D
@onready var gun_shot = $Head/Camera3D/Sniper/GunShot
@onready var footstep_audio = $Footstep


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
	
	# simulate mouse click to get rid of button
	call_deferred("right_click")
	
func right_click():
	var debug_right_click = InputEventMouseButton.new()
	debug_right_click.set_button_index(MOUSE_BUTTON_RIGHT)
	debug_right_click.set_pressed(true)
	Input.parse_input_event(debug_right_click)

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

	#sprinting
	if Input.is_action_pressed("sprint"):
		SPEED = SPRINT_SPEED
	else:
		SPEED = WAlK_SPEED

	

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


#press "shift" for testing of Respawn window
	#if Input.is_action_just_pressed("sprint"):
	#	get_tree().change_scene_to_file("res://Scripts/respawn_menu.tscn")
		

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 7.0) #move_toward(velocity.x, 0, SPEED)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 7.0) #move_toward(velocity.z, 0, SPEED)

	#else:
	#	velocity.x = 0.0 #move_toward(velocity.x, 0, SPEED)
	#	velocity.z = 0.0 #move_toward(velocity.z, 0, SPEED)
		
	# Gun controls
	if Input.is_action_pressed("Shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			gun_shot.play()
			
			# instantiate bullet based on raycast pos on gun barrel
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)
		

	#head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	#FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped

	move_and_slide()

func _play_footstep_audio():
	footstep_audio.pitch_scale = randf_range(.8, 1.2)
	footstep_audio.play()
	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	

func _on_regin_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
		

	
