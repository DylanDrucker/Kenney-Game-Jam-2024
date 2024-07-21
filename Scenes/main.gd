extends Node2D

var laser_scene: PackedScene = load("res://Scenes/laser.tscn") 
var missile_scene: PackedScene = load("res://Scenes/missile.tscn")

var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var enemy_down_scene: PackedScene = load("res://Scenes/enemy_down.tscn")
var enemy_left_right_scene: PackedScene = load("res://Scenes/enemy_left_right.tscn")

var small_star_scene: PackedScene = load("res://Scenes/smallstar.tscn")
var medium_star_scene: PackedScene = load("res://Scenes/medium_star.tscn")
var big_star_scene: PackedScene = load("res://Scenes/big_star.tscn")

var explosion_scene : PackedScene = load("res://Scenes/explosion.tscn")

var num_stars = -1
var width
@export var game_over_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	width = get_viewport().get_visible_rect().size[0]
	


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
	


func create_meteors(num):
	for i in range(num):
		var meteor = meteor_scene.instantiate()
		$Meteors.add_child(meteor)
		
		meteor.connect("collision",_on_collision)
		meteor.connect("explosion",on_explosion)

func create_enemies(enemy_type,num, offset):
	var num_enemies = num
	for i in range(num_enemies):
		var enemy = enemy_type.instantiate()
		$Enemies.add_child(enemy)
		enemy.position = Vector2((i)*(766/(num_enemies))+offset,-10)
		if enemy_type == enemy_left_right_scene:
			enemy.starting_pos = enemy.position.x
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
	var health_shield = $Player.take_damage(50)
	$Label3.adjust_health(health_shield[0])
	$Label4.adjust_shield(health_shield[1])
	

func _on_laser_collision():
	var health_shield = $Player.take_damage(10)
	$Label3.adjust_health(health_shield[0])
	$Label4.adjust_shield(health_shield[1])
signal update_score
func on_explosion(pos, velocity, rotation_speed):
	var explosion = explosion_scene.instantiate()
	explosion.position = pos
	explosion.velocity = velocity
	explosion.rotation_speed = rotation_speed
	$Explosions.add_child(explosion)
	
	update_score.emit()
	


func _on_game_over():
	get_tree().change_scene_to_file("res://game_over.tscn")


func _on_master_timer_timeout():
	create_enemies(enemy_down_scene,9,10)
	await get_tree().create_timer(2).timeout
	create_enemies(enemy_left_right_scene,9,50)
	await get_tree().create_timer(2).timeout
	create_meteors(10)
