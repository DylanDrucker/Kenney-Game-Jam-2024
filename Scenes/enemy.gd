extends Area2D

var laser_can_shoot := true
var speed := 25
var horizontal := 4
var width
@export var enemy_lives := 4

signal shoot_enemy_laser(pos)
signal explosion(pos)
# Called when the node enters the scene tree for the first time.
func _ready():
	width = get_viewport().get_visible_rect().size[0]
	position.x = 69

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(horizontal,1) * speed * delta
	if laser_can_shoot:
		emit_signal("shoot_enemy_laser", $LaserShoot.global_position)
		laser_can_shoot = false
		$ReloadTimer.start()
	if position.x > width - 50 or position.x < 50:
		horizontal *= -1

func _on_reload_timer_timeout():
	laser_can_shoot = true
	
func lose_life():
	enemy_lives -= 1
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property($body, "modulate", Color.RED, 0.1)
	tween.tween_property($Gun, "modulate", Color.RED, 0.1)
	tween.chain()
	tween.tween_property($body, "modulate", Color.WHITE, 0.1)
	tween.tween_property($Gun, "modulate", Color.WHITE, 0.1)
	tween.chain()
	
	if enemy_lives <= 0:
		emit_signal("explosion",global_position)
		self.queue_free()
		

func hit_by_meteor():
	emit_signal("explosion",global_position)
	self.queue_free()
	return false
