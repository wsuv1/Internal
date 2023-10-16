extends CanvasLayer


# pause game when menu called
func _ready():
	get_tree().paused = true


# when continue button is hit, return to game
func _on_ContinueButton_pressed():
	get_tree().paused = false
	queue_free()


# when main menu button is hit, return to starting scfeen
func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenuScreen.tscn")
