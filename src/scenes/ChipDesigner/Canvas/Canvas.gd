# tool
extends ViewportContainer

signal mouse_on
signal mouse_off

onready var viewport       := $Viewport
onready var camera         := $Viewport/Camera2D
onready var chip_container := $Viewport/Chips

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


func add_chip(chip_scene):
	
	var new_chip = chip_scene.instance()
	new_chip.position = chip_container.get_local_mouse_position()
	new_chip.prev_mouse_position = viewport.get_mouse_position()
	new_chip.is_dragged = true

	chip_container.add_child(new_chip)
