extends Node
class_name StateMachine

@export var initial_state : Deer_State

var current_state : Deer_State
var states : Dictionary = {}


func _ready():
	get_tree().root.get_node("World").get_node("DeerManager").open_season.connect(set_open_season)
	for child in get_children():
		if child is Deer_State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.enter()
		current_state = initial_state
	
func _process(delta):
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func set_open_season():
	on_child_transition(current_state, DeerAttacking)
	
func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.exit()

	new_state.enter()
	
	current_state = new_state
