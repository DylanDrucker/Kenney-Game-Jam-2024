extends Sprite2D

var rotation_speed
var lifetime
var target_scale
var target_rotation
# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	texture = load("res://Assets/explosions/explosion0"+str(rng.randi_range(0,8))+".png")
	scale = Vector2.ZERO
	target_scale = Vector2(1,1) * rng.randf_range(0.25,0.75)
	target_rotation = rng.randf_range(-PI,PI)
	lifetime = rng.randf_range(1,2)
	$AudioStreamPlayer.stream = load("res://Audio/explosionCrunch_00"+str(rng.randi_range(0,2))+".ogg")
	$AudioStreamPlayer.play()
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "scale", target_scale, 0.3)
	tween.tween_property(self,"rotation",target_rotation*(0.3/(0.3+lifetime)), 0.3)
	tween.chain()
	tween.tween_property(self, "modulate", Color(0,0,0,0), lifetime)
	tween.tween_property(self, "scale", Vector2(0.4,0.4), lifetime)
	tween.tween_property(self,"rotation",target_rotation, lifetime)
	tween.chain()
	await get_tree().create_timer(1).timeout
	self.queue_free
