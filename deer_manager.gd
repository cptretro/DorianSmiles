extends Node
class_name DeerManager

signal deer_killed(position)
signal open_season

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

# 
func spawn_deer(pos : Vector3):
	deer_kill_counter += 1
	print("spawn a deer")
	if deer_kill_counter > open_season_kill_requirement:
		open_season.emit() # alert all current dear to be angry
	
		
	var deerInstance = deer_scene.instantiate() # change to work w/ dynamic range
	get_tree().root.get_node("World").get_node("DeerManager").add_child(deerInstance) # Add deer to node of enemies
	pass
