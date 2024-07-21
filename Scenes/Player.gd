extends CharacterBody2D

@export var speed = 500

signal shoot_signal(pos_left,pos_right)
signal shoot_missile(pos)
var laser_timer: bool = true
var laser: bool = false
var missile: bool = false
var missile_timer: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(600,500)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()
	
	if Input.is_action_pressed("shoot"):
		if laser and laser_timer:
			emit_signal("shoot_signal",$LeftGunPosition.global_position, $RightGunPosition.global_position)
			laser_timer = false
			$LaserTimer.start()
		#change to if when we can do both missile and laser
		elif missile and missile_timer:
			emit_signal("shoot_missile",$MissilePosition.global_position)
			missile_timer = false
			$MissileTimer.start()
			
func on_tool_change(area_list):
	laser = "GUN" in area_list
	missile = "MISSILE" in area_list
	
	if "SPEED" in area_list:
		speed = 750
	else:
		speed = 500


func _on_timer_timeout():
	laser_timer = true


func _on_missile_timer_timeout():
	missile_timer = true
