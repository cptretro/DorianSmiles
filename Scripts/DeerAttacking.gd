extends Deer_State
class_name DeerAttacking

@export var enemy : CharacterBody3D

var player : CharacterBody3D

func attack():
	pass
		

func enter():
	pass
	
func exit():
	pass
	
func Physics_Update(delta: float):
	pass
	player = get_tree().root.get_node("World").get_node("Player")
	enemy.look_at(player.position)
	enemy.velocity = (player.position - enemy.position).normalized()
	
	if (player.position - enemy.position).length() < 2:
		attack() # inflict dmg on player
	
