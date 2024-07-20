extends Sprite2D

@export var area_type = "START"

var mouse_inside = false
signal mouse_in_area(type)
signal mouse_clicked_in_area(type)

func _input(event):
	if Input.is_action_just_pressed("draw"):
		if mouse_inside:
			mouse_clicked_in_area.emit(area_type)
	elif Input.is_action_pressed("draw"):
		if mouse_inside:
			mouse_in_area.emit(area_type)


func _on_area_2d_mouse_entered():
	mouse_inside = true
	


func _on_area_2d_mouse_exited():
	mouse_inside= false
