# tool
extends ViewportContainer

signal mouse_on
signal mouse_off

onready var viewport       := $Viewport
onready var camera         := $Viewport/Camera2D
onready var grid           := $Viewport/Grid
onready var chip_container := $Viewport/Chips
onready var wire_container := $Viewport/Wires
onready var wire_preview   := $Viewport/WirePreview

var solution            : String

var mouse_pos           : Vector2
var has_mouse           : bool    = false
var is_new_wire         : bool    = false
var new_wire_start      : Vector2
var is_new_wire_dir_set : bool    = false

var is_extend_wire      : bool    = false
var extending_wire      : Node2D

var Wire : PackedScene = preload("res://scenes/ChipDesigner/Wire/Wire.tscn")

func _ready():
	var half_viewport_size : Vector2 = viewport.get_visible_rect().size / 2
	camera.position = half_viewport_size


func _process(_delta):
	mouse_pos = grid.get_local_mouse_position()
	
	if viewport.get_visible_rect().has_point(viewport.get_mouse_position()):
		if has_mouse == false:
			emit_signal("mouse_on")
		has_mouse = true
	else:
		if has_mouse == true:
			emit_signal("mouse_off")
		has_mouse = false

	if has_mouse:
		if is_new_wire:
			if Input.is_action_just_released("ui_select"):
				end_new_wire()
			elif is_new_wire_dir_set == false:
				fix_new_wire_dir()
		elif (Input.is_action_just_pressed("ui_select") and
				CanvasInfo.entities_hovered <= 0):
			start_new_wire()
		elif is_extend_wire and Input.is_action_just_released("ui_select"):
			extending_wire.end_extend()


func add_chip(chip_scene: PackedScene):
	
	var new_chip = chip_scene.instance()
	new_chip.position = mouse_pos
	
	# TODO: THIS IS DISGUSTING FIX IT
	var sprite = new_chip.get_node("Sprite")
	new_chip.position -= sprite.get_rect().size * sprite.scale / 2
	
	new_chip.prev_mouse_position = viewport.get_mouse_position()
	new_chip.is_dragged = true

	chip_container.add_child(new_chip)


# Starts a new wire
func start_new_wire():
	wire_preview.start_pos = mouse_pos
	wire_preview.show()
	
	is_new_wire = true
	is_new_wire_dir_set = false
	
	new_wire_start = CanvasInfo.snap(mouse_pos)
	

# Fixes the wire preview's drag direction
func fix_new_wire_dir():
	var snapped_mouse_pos := CanvasInfo.snap(mouse_pos)
	
	if snapped_mouse_pos.x != new_wire_start.x:
		wire_preview.is_vert = false
		is_new_wire_dir_set = true
	elif snapped_mouse_pos.y != new_wire_start.y:
		wire_preview.is_vert = true
		is_new_wire_dir_set = true
	

# Creates a new wire node based on where the user dragged the mouse.
func end_new_wire():
	print_debug("Canvas: end_new_wire()")
	wire_preview.hide()
	
	var new_wire : Node2D = Wire.instance()
	if new_wire.connect("start_extend", self, "_on_Wire_start_extend") != OK:
		print_debug("Failed to connect signal.")
	if new_wire.connect("end_extend", self, "_on_Wire_end_extend") != OK:
		print_debug("Failed to connect signal.")
	if new_wire.connect("drag_dir", self, "_on_Wire_drag_dir") != OK:
		print_debug("Failed to connect signal.")
	wire_container.add_child(new_wire)
	new_wire.add_segment_path(new_wire_start, mouse_pos, wire_preview.is_vert)

func _on_Wire_start_extend(wire):
	is_extend_wire = true
	extending_wire = wire
	wire_preview.start_pos = mouse_pos
	wire_preview.show()


func _on_Wire_end_extend():
	wire_preview.hide()


func _on_Wire_drag_dir(is_vert: bool):
	wire_preview.is_vert = is_vert


func remove():
	queue_free()
