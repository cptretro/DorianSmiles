extends Deer_State
class_name DeerAttacking

@export var enemy : CharacterBody3D
@export var move_speed : float

var player : CharacterBody3D

func attack():
	# attack player here
	pass
		

func enter():
	pass
	
func exit():
	pass
	
func Physics_Update(delta: float):
	player = get_tree().root.get_node("World").get_node("Player")
	enemy.look_at(player.position)
	enemy.velocity = (player.position - enemy.position).normalized() * move_speed
	
	if (player.position - enemy.position).length() < 2:
		attack() # inflict dmg on player
	
