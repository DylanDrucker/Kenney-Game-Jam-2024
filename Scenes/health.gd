extends Label

var health = 100

signal game_over
func adjust_health(new_health):
	health = new_health
	if health <= 0:
		game_over.emit()
		health = 0
		
	text = "Health: " + str(health)
	
