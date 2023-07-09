extends CollisionShape3D


		
func take_damage(damage: float):
	print('take damage')
	health = clamp(health - damage, 0, 10)
	
	if health == 0:
		die()
		anim_tree.set("parameters/conditions/Death", true)
