extends Node2D

onready var label := $Label

func _process(_delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	label.text = str(mouse_pos)
