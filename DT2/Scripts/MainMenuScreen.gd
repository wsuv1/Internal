extends CanvasLayer


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
