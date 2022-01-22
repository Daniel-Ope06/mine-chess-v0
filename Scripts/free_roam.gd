extends KinematicBody2D

var tile_size = 22

var inputs = {
	"ui_up" 	: Vector2.UP,
	"ui_down"	: Vector2.DOWN,
	"ui_right"	: Vector2.RIGHT,
	"ui_left"	: Vector2.LEFT
}

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * tile_size

func _on_Area2D_selection_toggled(selection):
	set_process_unhandled_input(selection)
	


