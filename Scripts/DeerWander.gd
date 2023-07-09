extends Deer_State
class_name DeerWander

@export var enemy: CharacterBody3D
@export var move_speed := 2.0
@export var wander_range := 5

var player: CharacterBody3D
var starting_pos : Vector3
var move_direction : Vector3
var wander_time : float

func randomize_wander():
	move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1,1)).normalized()
	wander_time = randf_range(1, 3)
	
func return_to_spawn():
	move_direction = (starting_pos - enemy.position).normalized()
	wander_time = 4
	
func enter():
	wander_time = 0.0
	if enemy:
		enemy.velocity = Vector3.ZERO
	
	starting_pos = Vector3(enemy.position.x, enemy.position.y, 0)
	randomize_wander()
	
func exit():
	wander_time = 0.0
	enemy.velocity = Vector3.ZERO
	
func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		if starting_pos.distance_to(enemy.position) > wander_range:
			return_to_spawn()
		else:
			# roll dice on if deer wanders or grazes
			var roll : float = randf_range(1, 100)
			if fmod(roll, 2) == 0:
				randomize_wander()
			else:
				switch_to_graze()

func switch_to_graze():
	print("{DeerWander} to {DeerGrazing}")
	Transitioned.emit(self, "DeerGrazing")

func Physics_Update(_delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed
	
	player = get_tree().root.get_node("World").get_node("Player")
	#print(player)
	#print(enemy)
	
	var direction = Vector3(999,999,99)
	if player:
		direction = player.position - enemy.position
		#print(direction.length())
	else:
		print("Error: Player not found")

	if direction.length() < 2:
		print("{DeerWander} to {DeerIdle}")
		Transitioned.emit(self, "DeerIdle")
