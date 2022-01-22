extends Node2D

var move_tween
var sprite


func _ready():
	move_tween = $move_tween
	sprite = $Sprite

func move(target):
	move_tween.interpolate_property(self, "position", position, target, 0.3,
	Tween.TRANS_SINE, Tween.EASE_OUT)
	
	move_tween.start()

func dissolve():
	sprite.material.set_shader_param("dissolve_state", 0.3)


