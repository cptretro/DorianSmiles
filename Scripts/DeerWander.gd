extends Deer_State
class_name DeerWander

@export var enemy: CharacterBody3D
@export var move_speed := 2.0
@export var wander_range := 5

var player: CharacterBody3D
var starting_pos : Vector3
var move_direction : Vector3
var wander_time : float

func _ready():
	if !player:
		player = get_tree().root.get_node("World").get_node("Player")
	if !starting_pos:
		starting_pos = enemy.position

func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1,1)).normalized()
	wander_time = randf_range(1, 4)
	
func return_to_spawn():
	move_direction = (starting_pos - enemy.position).normalized()
	wander_time = 4
	
func enter():
	randomize_wander()
	
func exit():
	enemy.velocity = Vector3.ZERO
	wander_time = 1
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta

func switch_to_graze():
	#print("{DeerWander} to {DeerGrazing}")
	Transitioned.emit(self, "DeerGrazing")

func Physics_Update(_delta: float):
	if wander_time <= 0:
		if starting_pos.distance_to(enemy.position) > wander_range:
			return_to_spawn()
		else:
			# roll dice on if deer wanders or grazes
			var roll : float = randf_range(1, 100)
			if fmod(roll, 2) == 0:
				randomize_wander()
			else:
				switch_to_graze()

	else:
		enemy.velocity = move_direction * move_speed
	
		#player = get_tree().root.get_node("World").get_node("Player")

		var direction = Vector3(999,999,99)
		if player:
			direction = player.position - enemy.position
			#print(direction.length())
		else:
			#print("Error: Player not found")
			pass


		if direction.length() < 2:
			#print("{DeerWander} to {DeerIdle}")
			Transitioned.emit(self, "DeerIdle")
