extends CharacterBody3D
class_name DeerAi

#signal deer_killed(position)

@export var health := 100

@export var state_manager : StateMachine
@export var player: CharacterBody3D

func _ready():
	get_tree().root.get_node("World").get_node("DeerManager").deer_killed.connect(self.deer_is_killed)
	player = get_tree().root.get_node("World").get_node("Player")
	
	
func _physics_process(_delta):
	move_and_slide()

func take_damage(damage: float):
	health = clamp(health - damage, 0, 100)
	
	if health == 0:
		die()

func deer_is_killed(pos: Vector3):
	# Check if deer is nearby && we've progressed to scary deer
		# if nearby, tell state_manager to change state to eat_dead_bodies()
		
	print("Signal heard!", pos)
	
	
func die():
	#deer_killed.emit(position)
	pass
	# signal death?
