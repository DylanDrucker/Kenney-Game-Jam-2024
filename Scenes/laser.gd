extends Area2D

@export var laser_speed: float = 800
var direction = -1
var laser_colour = "green"
signal laser_collision()
signal enemy_laser_collision(area)
var height
# Called when the node enters the scene tree for the first time.
func _ready():
	height = get_viewport().get_visible_rect().size[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if laser_colour != "green":
		$Sprite2D.texture = load("res://Assets/Shooter/Lasers/laserRed16.png")
	position += Vector2(0,direction * laser_speed * delta)
	
	if position.y < -10 or position.y > height + 10:
		self.queue_free()

func _on_body_entered(body):
	emit_signal("laser_collision")
	self.queue_free()
	
func _on_area_entered(area):
	area.lose_life()
	self.queue_free()

func hit_by_meteor():
	self.queue_free()
	return false
