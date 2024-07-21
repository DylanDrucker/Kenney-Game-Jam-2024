extends Label


func adjust_shield(new_shield):
	text = "Shield: " + str(new_shield)
	


func _on_player_update_shield(new_shield):
	adjust_shield(new_shield)
