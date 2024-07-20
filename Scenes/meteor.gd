extends Area2D

var rand_v_speed
var rand_h_speed
var rand_rotation_speed
signal collision()
signal explosion(pos)
var height

# Called when the node enters the scene tree for the first time.
func _ready():
	var width = get_viewport().get_visible_rect().size[0]
	height = get_viewport().get_visible_rect().size[1]
	
	var rng = RandomNumberGenerator.new()
	var rand_x = rng.randf_range(0,776)
	rand_rotation_speed = rng.randf_range(-3,3)
	rand_v_speed = rng.randf_range(50,200)
	rand_h_speed = rng.randf_range(-50,50)
	var rand_size = rng.randf_range(0.5,1)#*(100/rand_speed)
	position = Vector2(rand_x, -50)
	scale = Vector2(1,1)*rand_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(rand_h_speed,rand_v_speed) * delta
	rotation += rand_rotation_speed * delta
	
	if position.y > height + 100:
		self.queue_free()

func _on_body_entered(body):
	emit_signal("collision")
	self.queue_free() 

func _on_area_entered(area):
	var should_meteor_die = area.hit_by_meteor()
	if should_meteor_die:
		emit_signal("explosion",global_position,Vector2(rand_h_speed,rand_v_speed),rand_rotation_speed)
		self.queue_free()
