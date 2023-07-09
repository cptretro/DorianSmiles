extends Node
class_name DeerManager

signal deer_killed(position)

@export var deer_scene : PackedScene # Deer Prefab

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# throw new NotImplementedExceptions()
	# test emit
	if Input.is_action_just_pressed("ui_accept"): ## enter key
		deer_killed.emit(Vector3.ZERO)

# 
func spawn_deer():
	var deerInstance = deer_scene.instantiate()
	deerInstance.position = Vector3.ZERO # change to work w/ dynamic range
	get_tree().get_node("DeerManager").add_child(deerInstance) # Add deer to node of enemies
	pass
