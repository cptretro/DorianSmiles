extends CharacterBody3D
class_name DeerAi

signal deer_killed

@export var health := 10

@export var state_manager : StateMachine
@export var player: CharacterBody3D
@export var open_season : bool
var state_machine

@onready var anim_tree = $AnimationTree
@onready var isDead = false


const ATTACK_RANGE = 2.5

@export var player_path : NodePath

func _ready():
	player = get_node(player_path)
	if !state_manager:
		state_manager = $StateMachine
	state_machine = anim_tree.get("parameters/playback")
		
	# Get Player reference
	if !player:
		player = get_tree().root.get_node("World").get_node("Player")
	# Not Implemented() :: Get signal from deer manager to look for nearby deer deaths

	#get_tree().root.get_node("World").get_node("DeerManager").deer_killed.connect(self.deer_is_killed)
	

	
func _physics_process(_delta):

	match state_machine.get_current_node():
		"horse_rig_attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/Run", !_target_in_range())

	
	anim_tree.get("parameters/playback")
	
	move_and_slide()
	
# Damage Script, clamps value to 0
func take_damage(damage: float):
	health = clamp(health - damage, 0, 10)
	
	if health == 0:
		die()

func deer_is_killed(pos: Vector3):
	# throw NotImplementedException()
	pass
	# Check if deer is nearby && we've progressed to scary deer
		# if nearby, tell state_manager to change state to eat_dead_bodies()
		
	#print("Signal heard!", pos)

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.distance_to(player.global_position)
		player.damage()
	
func die():
	# throw new NotImplementedException()
	deer_killed.emit()
	anim_tree.set("parameters/conditions/Death", true)
	print('dead')
	
	queue_free()
	
	#$superdeerhorse/AnimationPlayer.play("horse_rig_Run")
	pass
