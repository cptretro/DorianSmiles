extends Control



# respawn button
func _on_Respawn_pressed():
	get_tree().reload_current_scene()
	


# main menu button
func _on_Main_Menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	
