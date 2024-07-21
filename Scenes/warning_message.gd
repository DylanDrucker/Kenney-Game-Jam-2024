extends Label


func _ready():
	visible = false

func show_message(warning_text):
	text = "Warning: " + warning_text
	for i in range(3):
		visible = true
		await get_tree().create_timer(0.5).timeout
		visible = false
		await get_tree().create_timer(0.5).timeout
