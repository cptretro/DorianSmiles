extends CharacterBody3D
class_name DeerAi

#signal deer_killed(position)

@export var health := 10

@export var state_manager : StateMachine
@export var player: CharacterBody3D

@export var open_season : bool

var deadcount = 0

func _ready():
	if !state_manager:
		state_manager = $StateMachine
		
	# Get Player reference
	if !player:
		player = get_tree().root.get_node("World").get_node("Player")
	# Not Implemented() :: Get signal from deer manager to look for nearby deer deaths

	get_tree().root.get_node("World").get_node("DeerManager").deer_killed.connect(self.deer_is_killed)
	

	
func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() > 0 and deadcount < 1:
		$superdeerhorse/AnimationPlayer.play("horse_rig_Run")
		rotation.y = lerp_angle(rotation.y, atan2(- velocity.x, - velocity.z), 1)
	elif velocity.length() <= 0 and deadcount < 1:
		$superdeerhorse/AnimationPlayer.play("horse_rig_eat")
		
	#if !starting_pos and is_on_floor():
	#	starting_pos = enemy.position
		
	
	velocity.y -= 9.7 * _delta


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
	
	
func die():
	# throw new NotImplementedException()
	print('dead')
	deadcount += 1
	$superdeerhorse/AnimationPlayer.play("horse_rigdeath")

