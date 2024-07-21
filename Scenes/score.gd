extends Label

var score = 0

func update_score(new_score):
	new_score = str(new_score)
	while len(new_score) <= 5:
		new_score = '0' + new_score
	
	text = "Score: " + new_score



func _on_game_update_score():
	score += 100
	update_score(score)
