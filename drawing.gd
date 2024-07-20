extends Node2D


var positions = []

@onready var TOP_LEFT = $TileMap/TopLeft.global_position
@onready var BOTTOM_RIGHT = $TileMap/BottomRight.global_position

var new_line = true

var area_list = []
var enabled = false


@onready var missile = $TileMap/Missile
@onready var gun = $TileMap/Gun
@onready var shield = $TileMap/Shield

var areas = []

var valid_wire = false

func _ready():
	$TileMap.visible = false
	areas = [missile, gun, shield]

signal valid_areas(weapons)


func _input(event):
	if Input.is_action_pressed("draw"):
		if enabled:
			if new_line:
				new_line = false
				positions = []
				area_list = []
				valid_wire = false
			var pos = get_global_mouse_position()
			var x = clamp(pos.x, TOP_LEFT.x, BOTTOM_RIGHT.x)
			var y = clamp(pos.y, TOP_LEFT.y, BOTTOM_RIGHT.y)
			
			positions.append(Vector2(x,y))
			queue_redraw()
	
	elif Input.is_action_just_released("draw"):
		print(area_list)
		new_line = true
		enabled = false
		if invalid_wire():
			positions = []
			area_list = []
			queue_redraw()
		else:
			valid_wire = true
			queue_redraw()
			print('closing')
			$Button.visible = true
			$TileMap.visible = false
			valid_areas.emit(area_list)
		
			positions = []
			queue_redraw()
			

func _draw():
	var width = 12 - 3 * len(area_list)
	var color = Color.RED
	if valid_wire:
		color = Color.YELLOW
		width += 5
		if len(area_list) > 4:
			width = 0
	draw_polyline(positions, color, width)
		
func invalid_wire():
	if len(area_list) == 0 or len(area_list) > 4:
		return true
	if area_list[0] == "START" and area_list[-1] == "END":
		return false
	else:
		return true

func update_area_list(type):
	if type not in area_list:
		area_list.append(type)




func _on_button_pressed():
	$Button.visible = false
	valid_wire = false
	positions = []
	area_list = []
	randomise_area_locations()
	$TileMap.visible = true
	
	
func randomise_area_locations():
	var positions_so_far = [$TileMap/Start.global_position, $TileMap/End.global_position]
	var border = 20
	for area in areas:
		var random_x = randi_range(TOP_LEFT.x + border, BOTTOM_RIGHT.x - border)
		var random_y = randi_range(TOP_LEFT.y + border, BOTTOM_RIGHT.y - border)
		var random_position = Vector2(random_x, random_y)
		
		var valid_position = false
		var overlap_range = 20

		while not valid_position:
			valid_position = true
			for p in positions_so_far:
				var overlap = false
				if random_position.x < p.x + overlap_range and random_position.x > p.x - overlap_range:
					overlap = true
				elif random_position.y < p.y + overlap_range and random_position.y > p.y - overlap_range:
					overlap = true
				
				if overlap:
					valid_position = false
					random_x = randi_range(TOP_LEFT.x + border, BOTTOM_RIGHT.x - border)
					random_y = randi_range(TOP_LEFT.y + border, BOTTOM_RIGHT.y - border)
					random_position = Vector2(random_x, random_y)
					print("new position")
					
					
		area.position = random_position
		positions_so_far.append(random_position)
		print(area.position)

func _on_mouse_clicked_in_area(type):
	if type == "START":
		enabled = true
		update_area_list(type)

func _on_mouse_in_area(type):
	if type == 'END':
		enabled = false
		if len(area_list) < 5:
			valid_wire = true
			queue_redraw()
	update_area_list(type)
