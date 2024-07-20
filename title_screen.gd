extends Node2D

@export var main_scene : PackedScene
@export var tutorial_scene : PackedScene


func _on_quit_button_pressed():
	get_tree().quit()
	



func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)


func _on_tutorial_button_pressed():
	get_tree().change_scene_to_packed(tutorial_scene)
