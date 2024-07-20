extends Sprite2D

var rand_speed
var texture_type :int = 1

var height

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(height)
	var rng := RandomNumberGenerator.new()
	var width = get_viewport().get_visible_rect().size[0]
	height = get_viewport().get_visible_rect().size[1]
	var rand_x = rng.randf_range(0,776)
	var rand_y = rng.randf_range(-50,-100)
	var rand_z = rng.randf_range(0.5,1)
	var rand_size = rng.randf_range(0.6,1.2)*rand_z
	rand_speed = rng.randf_range(250,500)*rand_z
	self.global_position = Vector2(rand_x,rand_y)
	scale = Vector2(1,1)*rand_size
	$TwinkleTimer.start(rng.randf_range(0.3,2))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0,1) * delta * rand_speed
	if position[1] > height + 100:
		self.queue_free()

func _on_twinkle_timer_timeout():
	texture = load("res://Assets/Shooter/Effects/star"+ str(texture_type) +".png")
	if texture_type == 1:
		texture_type = 2
	else: 
		texture_type = 1
