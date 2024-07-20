extends Sprite2D

@export var area_type = "START"

var mouse_inside = false
signal mouse_in_area(type)
signal mouse_clicked_in_area(type)

func _ready():
	$AnimationPlayer.play("scale")
	if area_type not in ['START', 'END']:
		$Label.text = area_type
	else:
		$Label.text = ""

func _input(event):
	if Input.is_action_just_pressed("draw"):
		if mouse_inside:
			mouse_clicked_in_area.emit(area_type)

	elif Input.is_action_pressed("draw"):
		if mouse_inside:
			mouse_in_area.emit(area_type)


func bob_up():
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y - 10), 0.2)
	await tween.finished
	tween.tween_property(self, "position", Vector2(position.x, position.y + 10), 0.1)
	await tween.finished
	


func _on_area_2d_mouse_entered():
	mouse_inside = true
	

func _on_area_2d_mouse_exited():
	mouse_inside= false
	

