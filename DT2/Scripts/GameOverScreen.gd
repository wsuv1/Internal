extends CanvasLayer

# node variables
onready var title = $PanelContainer/MarginContainer/Rows/Title


# set title text and colour when game has been won/lost
func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.green
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.red


# when pressing restart button, return to new game
func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Main.tscn")


# when pressing quit, exit godot
func _on_QuitButton_pressed():
	get_tree().quit()


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenuScreen.tscn")
