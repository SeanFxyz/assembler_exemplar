# tool
extends ViewportContainer

signal mouse_on
signal mouse_off

onready var viewport       := $Viewport
onready var camera         := $Viewport/Camera2D
onready var chip_container := $Viewport/Chips
onready var wire_container := $Viewport/Wires

var has_mouse := true

var Wire : PackedScene = preload("res://scenes/ChipDesigner/Wire/Wire.tscn")

func _ready():
	var half_viewport_size : Vector2 = viewport.get_visible_rect().size / 2
	camera.position = half_viewport_size


func _process(_delta):
	if viewport.get_visible_rect().has_point(viewport.get_mouse_position()):
		if has_mouse == false:
			emit_signal("mouse_on")
		has_mouse = true
	else:
		if has_mouse == true:
			emit_signal("mouse_off")
		has_mouse = false

	if (has_mouse and
			Input.is_action_just_pressed("ui_select") and
			CanvasInfo.entities_hovered <= 0):
		add_wire()


func add_chip(chip_scene: PackedScene):
	
	var new_chip = chip_scene.instance()
	new_chip.position = chip_container.get_local_mouse_position()
	new_chip.prev_mouse_position = viewport.get_mouse_position()
	new_chip.is_dragged = true

	chip_container.add_child(new_chip)


func add_wire():
	var new_wire = Wire.instance()
	wire_container.add_child(new_wire)
	new_wire.add_seg_at_mouse()
