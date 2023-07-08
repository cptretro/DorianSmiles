extends Node3D

@onready var obj = $"."

func _process(delta):
	obj.position.x = lerp(obj.position.x,-0.614,delta*5)
	obj.position.y = lerp(obj.position.y,-0.579,delta*5)

	
func sway(sway_amount):
	obj.position.x += sway_amount.x*0.0001
	obj.position.y += sway_amount.y*0.0001


func _input(event):
	if event is InputEventMouseMotion:
		obj.sway(Vector2(event.relative.x ,event.relative.y ))
