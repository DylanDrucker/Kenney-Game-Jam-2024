extends Label

func _ready():
	visible = false

func show_warning(warning_text):
	text = ""
	visible = true
	text = warning_text
	await get_tree().create_timer(2).timeout
	visible = false
	
