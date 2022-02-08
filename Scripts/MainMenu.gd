extends Node2D



func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://UI/ChessDisplay.tscn")
