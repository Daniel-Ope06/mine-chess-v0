extends CanvasLayer

onready var winner = $PanelContainer/MarginContainer/VBoxContainer1/Winner

func set_winner(white: bool):
	if white:
		winner.text = "White Won!"
		winner.modulate = Color(167, 176, 183)
	else:
		winner.text = "Black Won!"
		winner.modulate = Color(0, 0, 0)

func _on_RestartButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://UI/ChessDisplay.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

