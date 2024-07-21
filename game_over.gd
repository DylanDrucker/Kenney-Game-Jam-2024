extends Control


func _ready():
	$Button.visible = false
	$Label.visible = false
	$AnimatedSprite2D.visible = false
	
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()
	await $AnimatedSprite2D.animation_finished
	
	$AnimatedSprite2D.visible = false
	
	$Button.visible = true
	$Label.visible = true
	


func _on_button_pressed():
	get_tree().change_scene_to_file("res://title_screen.tscn")
