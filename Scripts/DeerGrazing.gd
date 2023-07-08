extends Deer_State
class_name DeerGrazing

var graze_time : float

func graze():
	graze_time = randf_range(3, 8)
	print("Grazing for: ", graze_time)
	
func enter():
	graze()
	pass

func exit():
	pass
	
func Update(delta: float):
	if graze_time > 0:
		graze_time -= delta
		#print(graze_time)
	else:
		print("{DeerGrazing} to {DeerWander}")
		Transitioned.emit(self, "Deer")
