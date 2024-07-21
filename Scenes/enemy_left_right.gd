extends Area2D

var laser_can_shoot := true
var speed := 25
var horizontal := 4
var down_speed = 1
var width
var reload_time = 1
var starting_pos : float = 50
@export var moving := 50
@export var enemy_lives := 4

signal shoot_enemy_laser(pos)
signal explosion(pos)
signal player_hit_ship()
# Called when the node enters the scene tree for the first time.
func _ready():
	width = get_viewport().get_visible_rect().size[0]
	starting_pos = position.x
	$LeaveTimer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(horizontal,down_speed) * speed * delta
	if laser_can_shoot:
		emit_signal("shoot_enemy_laser", $LaserShoot.global_position)
		laser_can_shoot = false
		$ReloadTimer.start(reload_time)
	if position.x < starting_pos - moving or position.x > starting_pos + moving:
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
	reload_time *= 1.5
	$ReloadTimer.start(reload_time)
	if enemy_lives <= 0:
		emit_signal("explosion",global_position,Vector2(horizontal,down_speed) * speed,0)
		self.queue_free()
		

func hit_by_meteor():
	emit_signal("explosion",global_position,Vector2(horizontal,down_speed) * speed,0)
	self.queue_free()
	return false


func _on_leave_timer_timeout():
	down_speed = 8

func _on_area_entered(area):
	if area.is_in_group("Missile"):
		emit_signal("explosion",global_position,Vector2(horizontal,down_speed) * speed,0)
		area.queue_free()
		self.queue_free()

func _on_body_entered(body):
	emit_signal("player_hit_ship")
	emit_signal("explosion",global_position,Vector2(horizontal,down_speed) * speed,0)
	self.queue_free()
