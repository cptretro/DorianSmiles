extends Control


func _ready():
	$VBoxContainer/Respawn.grab_focus()


#repawn button
func _on_respawn_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

#main menu button
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
