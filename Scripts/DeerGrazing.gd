extends Deer_State
class_name DeerGrazing

var graze_time : float

func graze():
	graze_time = randf_range(3, 8)
	print("grazing for :", graze_time)
	
func enter():
	graze()
	pass

func exit():
	graze_time = 0
	pass
	
func Update(delta: float):
	if graze_time > 0:
		graze_time -= delta
	else:
		print("{DeerGrazing} to {DeerWander}")
		Transitioned.emit(self, "DeerWander")
