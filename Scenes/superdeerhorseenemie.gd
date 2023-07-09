extends CharacterBody3D


const SPEED = 2
const ATTACK_RANGE = 2.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player = null
var state_machine
var damage = 10

@export var health := 10
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	velocity =Vector3.ZERO
	
	match state_machine.get_current_node():
		"horse_rig_Run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point -global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(- velocity.x, - velocity.z), delta * 10)
			
		"horse_rig_attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	



	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/Run", !_target_in_range())

	
	anim_tree.get("parameters/playback")
	
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.distance_to(player.global_position)
		player.damage()
		
func take_damage(damage: float):
	health = clamp(health - damage, 0, 10)
	
	if health == 0:
		die()
		anim_tree.set("parameters/conditions/Death", true)
		

func die():
	# throw new NotImplementedException()
	print('dead')
