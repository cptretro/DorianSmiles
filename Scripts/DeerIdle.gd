extends Deer_State
class_name DeerIdle

@export var enemy : CharacterBody3D

var player: CharacterBody3D
var idle_time : float

func idle():
	idle_time = randf_range(5, 11)
	print("Idle for: ", idle_time)
	
func enter():
	idle_time = 0
	idle()
	

func exit():
	idle_time = 0
	
func Update(delta: float):
	if idle_time > 0:
		idle_time -= delta
	else:
		player = get_tree().root.get_node("World").get_node("Player")
		#print(player)
		
		var direction = Vector3(999,999,99)
		if player:
			direction = player.position - enemy.position
			print(direction.length())
		else:
			print("Error: Player not found")
		
		# Continue to watch if player does not leave extended area
		if direction.length() < 5:
			idle()
		else:
			print("{DeerIdle} to {DeerWander}")
			Transitioned.emit(self, "DeerWander")
		
func Physics_Update(_delta: float):
	player = get_tree().root.get_node("World").get_node("Player")
	enemy.look_at(player.position)
