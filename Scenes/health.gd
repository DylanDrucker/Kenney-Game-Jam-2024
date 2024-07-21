extends Label

var health = 100

signal game_over
func adjust_health(damage):
	health = clamp(health - damage, 0, 100)
	if health == 0:
		game_over.emit()
		
	text = "Health: " + str(health)
	
