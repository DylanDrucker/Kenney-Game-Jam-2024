extends Area2D

signal hit_by_meteor_internal()

func hit_by_meteor():
	emit_signal("hit_by_meteor_internal")
	return true
