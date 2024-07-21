extends Label




func _on_drawing_valid_areas(weapons):
	text = ""
	var new_text = ""
	for weapon in weapons:
		if weapon == 'GUN':
			new_text += "Laser"
			new_text += '\n'
		elif weapon not in ['START', 'END']:
			new_text += weapon
			new_text += '\n'
	if new_text == "":
		new_text = 'None'
		
	text = new_text
			
func _on_player_lose_shield():
	text = text.replace("SHIELD","")
