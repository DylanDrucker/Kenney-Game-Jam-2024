extends Node2D


var positions = []

const TOP_LEFT = [828, 418]
const BOTTOM_RIGHT = [1147, 635]

var new_line = true

var area_list = []
var enabled = false

func _input(event):
	if Input.is_action_pressed("draw"):
		if enabled:
			if new_line:
				new_line = false
				positions = []
				area_list = []
			var pos = get_global_mouse_position()
			var x = clamp(pos.x, TOP_LEFT[0], BOTTOM_RIGHT[0])
			var y = clamp(pos.y, TOP_LEFT[1], BOTTOM_RIGHT[1])
			
			positions.append(Vector2(x,y))
			queue_redraw()
	
	elif Input.is_action_just_released("draw"):
		new_line = true
		enabled = false
		if invalid_wire():
			positions = []
			area_list = []
			queue_redraw()

func _draw():
	draw_polyline(positions, Color.RED, 5)
		
func invalid_wire():
	if len(area_list) == 0:
		return true
	if area_list[0] == "START" and area_list[-1] == "END":
		return false
	else:
		return true

func _on_wire_area_mouse_in_area(area_type):
	area_list.append(area_type)


func _on_wire_area_mouse_clicked_in_area(type):
	if type == "START":
		enabled = true
		
