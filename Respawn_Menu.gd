extends Control


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$VBoxContainer/Respawn.grab_focus()
	var format_str = "You survived %s seconds!"
	$Label.text = format_str % str(int(round(Stopwatch.time_alive)))


#repawn button
func _on_respawn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Forest.tscn")

#main menu button
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
