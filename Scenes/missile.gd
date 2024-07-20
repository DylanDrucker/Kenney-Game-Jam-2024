extends Node2D

@export var missile_speed := 300
var target
var current_velocity := Vector2.ZERO
var drag_factor := 0.1
var array = []
var height
var width
# Called when the node enters the scene tree for the first time.
func _ready():
	current_velocity = Vector2.UP.rotated(rotation) * missile_speed * 3
	
	height = get_viewport().get_visible_rect().size[1]
	width = get_viewport().get_visible_rect().size[0]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction := Vector2.UP.rotated(rotation).normalized()
	
	if target:
		direction = global_position.direction_to(target.global_position)
	
	var desired_velocity := direction * missile_speed
	var change := (desired_velocity - current_velocity) * drag_factor

	current_velocity += change
	position += current_velocity * delta
	
	look_at(global_position + current_velocity)
	rotate(PI/2)
	
	if position.y < -20 or position.y > height + 50:
		self.queue_free()
		
	if position.x < -50 or position.x > width + 50:
		self.queue_free()

func _on_area_2d_area_entered(area):
	if target == null:
		target = array.pop_front()
		if target == null:
			target = area
	else:
		array.append(area)

func _on_area_2d_area_exited(area):
	target = null

func _on_missile_hit_by_meteor_internal():
	self.queue_free()
