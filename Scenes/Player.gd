extends CharacterBody2D

@export var speed = 500

signal shoot_signal(pos_left,pos_right)
signal shoot_missile(pos)
var laser_timer: bool = true
var laser: bool = false
var missile: bool = false
var missile_timer: bool = true
var shield = 100
var health = 100
var regen: bool = false
var shield_on: = false
var health_regen_speed = 1
var shield_regen_speed = 1

signal update_shield(shield)
signal update_health(health)
signal lose_shield()

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
	regen = "REGEN" in area_list
	if regen:
		$HealthRegenTimer.start()
	else:
		$HealthRegenTimer.stop()
	shield_on =  "SHIELD" in area_list
	if shield_on:
		$Shield.visible = true
		$ShieldRegenTimer.start()
	else:
		$Shield.visible = false
		$ShieldRegenTimer.stop()
	if "SPEED" in area_list:
		speed = 500
	else:
		speed = 250
	
	
		
func take_damage(damage):
	var damage_taken = damage
	if shield_on:
		shield -= damage_taken
		if shield < 0:
			shield_on = false
			$ShieldRegenTimer.stop()
			$Shield.visible = false
			emit_signal("lose_shield")
			health += shield
			shield = 0
	else:
		health-= damage_taken
	return Vector2(health, shield)


func _on_timer_timeout():
	laser_timer = true


func _on_missile_timer_timeout():
	missile_timer = true


func _on_shield_regen_timer_timeout():
	if shield < 100:
		shield += shield_regen_speed
	emit_signal("update_shield", shield)


func _on_health_regen_timer_timeout():
	if health < 100:
		health  += health_regen_speed
	emit_signal("update_health", health)
