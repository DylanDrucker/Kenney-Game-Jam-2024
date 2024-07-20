extends Node2D

var laser_scene: PackedScene = load("res://Scenes/laser.tscn") 
var missile_scene: PackedScene = load("res://Scenes/missile.tscn")

var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var enemy_scene: PackedScene = load("res://Scenes/enemy.tscn")

var small_star_scene: PackedScene = load("res://Scenes/smallstar.tscn")
var medium_star_scene: PackedScene = load("res://Scenes/medium_star.tscn")
var big_star_scene: PackedScene = load("res://Scenes/big_star.tscn")

var explosion_scene : PackedScene = load("res://Scenes/explosion.tscn")

var num_stars = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_shoot_signal(pos_left, pos_right):
	var laser1 = laser_scene.instantiate()
	var laser2 = laser_scene.instantiate()
	laser1.position = pos_left
	laser2.position = pos_right
	$Lasers.add_child(laser1)
	$Lasers.add_child(laser2)

func _on_player_shoot_missile(pos):
	var missile = missile_scene.instantiate()
	missile.position = pos
	$Missiles.add_child(missile)


func _on_timer_timeout():
	num_stars+=1
	var star
	if num_stars < 8:
		star = small_star_scene.instantiate()
	elif num_stars < 10:
		star = medium_star_scene.instantiate()
	else:
		star = big_star_scene.instantiate()
		num_stars = -1
	$BackgroundStars.add_child(star)
	


func _on_meteor_timer_timeout():
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	
	meteor.connect("collision",_on_collision)
	meteor.connect("explosion",on_explosion)

func _on_enemy_timer_timeout():
	var enemy = enemy_scene.instantiate()
	$Enemies.add_child(enemy)
	
	enemy.connect("shoot_enemy_laser", on_enemy_laser)
	enemy.connect("explosion",on_explosion)
	
func on_enemy_laser(pos):
	var laser = laser_scene.instantiate()
	laser.position = pos
	laser.direction = 1
	laser.laser_colour = "red"
	laser.connect("laser_collision",_on_laser_collision)
	$Lasers.add_child(laser)
	
func _on_collision():
	print("meteor collided")

func _on_laser_collision():
	print("laser collided")

func on_explosion(pos, velocity, rotation_speed):
	var explosion = explosion_scene.instantiate()
	explosion.position = pos
	explosion.velocity = velocity
	explosion.rotation_speed = rotation_speed
	$Explosions.add_child(explosion)
