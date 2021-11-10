# tool
extends ViewportContainer

signal mouse_on
signal mouse_off

onready var viewport := $Viewport
var has_mouse := true

func _process(_delta):
	if viewport.get_visible_rect().has_point(viewport.get_mouse_position()):
		if has_mouse == false:
			emit_signal("mouse_on")
		has_mouse = true
	else:
		if has_mouse == true:
			emit_signal("mouse_off")
		has_mouse = false
