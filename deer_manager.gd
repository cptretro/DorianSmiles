extends Node
class_name DeerManager

signal deer_killed(position)
signal open_season

@export var is_open_season :=  0

@export var open_season_kill_requirement := 5
var deer_kill_counter : int
@export var deer_scene : PackedScene # Deer Prefab

# Called when the node enters the scene tree for the first time.
func _ready():
	deer_kill_counter = 0
	deer_killed.connect(spawn_deer)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# throw new NotImplementedExceptions()
	# test emit
	if Input.is_action_just_pressed("ui_accept"): ## enter key
		deer_killed.emit(Vector3.ZERO)
	if Input.is_action_just_pressed("start_open_season"): ## enter key
		open_season.emit()
	

# 
func spawn_deer(pos : Vector3):
	deer_kill_counter += 1
	print("spawn two deer")
	
	if deer_kill_counter > open_season_kill_requirement:
		open_season.emit() # alert all current dear to be angry
	
		
	
	for i in range(2):	
		var deerInstance = deer_scene.instantiate() # change to work w/ dynamic range
	
		deerInstance.position = Vector3(randf_range(0, 165), 50, randf_range(-90, 0))
		
		if is_open_season == 1:
			deerInstance.get_node("StateMachine").initial_state == DeerAttacking # there's no way this works
		get_tree().root.get_node("World").get_node("DeerManager").add_child(deerInstance) # Add deer to node of enemies
	pass
