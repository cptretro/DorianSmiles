extends Node3D


var mesh_size
@onready var viewport =$Viewport
@onready var panel_fave = $MeshInstance3D
@onready var touch_area = $MeshInstance3D/Area3D


var is_mouse_held = false
var is_mouse_inside = false
var last_mouse_position3d = null
var last_mouse_position2d = null


func _ready():
	touch_area.connect("mouse_entered", self, "_mouse_entered_touch_area")
	
func _mouse_entered_touch_area():
	is_mouse_inside = true

func _input(event):
	var is_mouse_event = false
	
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion]:
		if event is mouse_event:
			is_mouse_event = true
		if is_mouse_event:
			handle_mouse(event)
		elif not is_mouse_event:
			viewport.event(event)
			
func handle_mouse(event):
	pass
