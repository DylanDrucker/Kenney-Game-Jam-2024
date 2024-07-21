extends Control




func _on_button_pressed():
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://weapons.tscn")
