# tool
extends Control

signal mouse_on
signal mouse_off
signal save_requested(sav_data)

onready var viewport         := $ViewportContainer/Viewport
onready var camera           := $ViewportContainer/Viewport/Camera2D
onready var grid             := $ViewportContainer/Viewport/Grid
onready var input_container  := $ViewportContainer/Viewport/Inputs
onready var output_container := $ViewportContainer/Viewport/Outputs
onready var chip_container   := $ViewportContainer/Viewport/Chips
onready var wire_container   := $ViewportContainer/Viewport/Wires
onready var wire_preview     := $ViewportContainer/Viewport/WirePreview
onready var color_picker     := $ColorPicker
onready var new_wire_color   : Color = color_picker.default

var enabled             : bool    = true setget set_enabled

var solution            : String     = "default"
var input_nodes         : Dictionary = {}
var output_nodes        : Dictionary = {}

var mouse_pos           : Vector2
var has_mouse           : bool    = false
var is_new_wire         : bool    = false
var new_wire_start      : Vector2
var is_new_wire_dir_set : bool    = false

var is_extend_wire      : bool    = false
var extending_wire      : Node2D

var circuit_chip_spec   : ChipSpec

var _last_wire_id       : int
var _last_chip_id       : int

var CircuitInput := preload("res://scenes/ChipDesigner/CanvasChips/CircuitInput.tscn")
var CircuitOutput := preload("res://scenes/ChipDesigner/CanvasChips/CircuitOutput.tscn")
var Wire := preload("res://scenes/ChipDesigner/Wire/Wire.tscn")


func _ready() -> void:
	
	
	camera.position = viewport.get_visible_rect().size / 2
	circuit_chip_spec = ChipIO.chip_specs[PlayerData.current_level]
	_last_wire_id = -1
	_last_chip_id = -1
	
	solution = PlayerData.current_solution
	populate(PlayerData.cur_solution_data)


func _process(_delta) -> void:
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
				(CanvasInfo.entities_hovered <= 0 or
					CanvasInfo.chip_io_hovered > 0)):
			start_new_wire()
		elif is_extend_wire and Input.is_action_just_released("ui_select"):
			extending_wire.end_extend()


func set_enabled(new_value: bool) -> void:
	enabled = new_value
	set_process(new_value)
	set_process_input(new_value)
	set_process_unhandled_input(new_value)
	set_process_unhandled_key_input(new_value)
	has_mouse = new_value


func simulate_inputs(inputs: Dictionary) -> Dictionary:
	var outputs := {}
	
	# Initialize inputs nodes' held values.
	for input_name in inputs.keys():
		input_nodes[input_name].value = inputs[input_name]
	
	return outputs


func populate(data: Dictionary) -> void:
	for input in data["inputs"].keys():
		var input_grid_pos : Array = data["inputs"][input]
		var new_circuit_input : Area2D = CircuitInput.instance()
		new_circuit_input.input_name = input
		new_circuit_input.input_width = circuit_chip_spec.input_widths[input]
		new_circuit_input.position = CanvasInfo.arr_to_pos(input_grid_pos)
		input_container.add_child(new_circuit_input)
		input_nodes[input] = new_circuit_input
	
	for output in data["outputs"].keys():
		var output_grid_pos : Array = data["outputs"][output]
		var new_circuit_output : Area2D = CircuitOutput.instance()
		new_circuit_output.output_name = output
		new_circuit_output.position = CanvasInfo.arr_to_pos(output_grid_pos)
		output_container.add_child(new_circuit_output)
		output_nodes[output] = new_circuit_output
	
	# TODO: populate chips and wires from save data


func get_input_values() -> Dictionary:
	var result := {}
	
	for input in input_container.get_children():
		result[input.input_name] = input.input_state
	
	return result


func get_output_values() -> Dictionary:
	var result := {}
	
	for output in output_container.get_children():
		result[output.output_name] = output.input_state
	
	return result


func set_input_values(input_set: Dictionary) -> void:
	for input_name in input_set.keys():
		input_nodes[input_name].set_input_state("", input_set[input_name])


func add_chip(chip_scene: PackedScene, pos: Vector2) -> void:
	
	var new_chip = chip_scene.instance()
	new_chip.position = pos
	
	# TODO: THIS IS DISGUSTING FIX IT
	var sprite : Sprite = new_chip.get_node("Sprite")
	new_chip.position -= sprite.get_rect().size * sprite.scale / 2

	chip_container.add_child(new_chip)


func add_chip_on_mouse(chip_scene: PackedScene) -> void:
	var new_chip = chip_scene.instance()
	new_chip.position = mouse_pos
	
	# TODO: THIS IS GROSS FIX IT
	var sprite : Sprite = new_chip.get_node("Sprite")
	new_chip.position -= sprite.get_rect().size * sprite.scale / 2
	
	new_chip.prev_mouse_position = viewport.get_mouse_position()
	new_chip.is_dragged = true

	chip_container.add_child(new_chip)


# Starts a new wire
func start_new_wire() -> void:
	print_debug("Canvas: Starting new wire")
	
	is_new_wire = true
	is_new_wire_dir_set = false
	
	wire_preview.start_pos = mouse_pos
	wire_preview.show()
	
	new_wire_start = CanvasInfo.snap(mouse_pos)
	

# Fixes the wire preview's drag direction
func fix_new_wire_dir() -> void:
	var snapped_mouse_pos := CanvasInfo.snap(mouse_pos)
	
	if snapped_mouse_pos.x != new_wire_start.x:
		wire_preview.is_vert = false
		is_new_wire_dir_set = true
	elif snapped_mouse_pos.y != new_wire_start.y:
		wire_preview.is_vert = true
		is_new_wire_dir_set = true
	

# Creates a new wire node based on where the user dragged the mouse.
func end_new_wire() -> void:
	is_new_wire = false
	
	wire_preview.hide()
	
	var new_wire : Node2D = Wire.instance()
	new_wire.wire_id = _next_wire_id()
	new_wire.color = new_wire_color
	wire_container.add_child(new_wire)
	new_wire.add_segment_path(new_wire_start, mouse_pos, wire_preview.is_vert)
	
	if new_wire.connect("start_extend", self, "_on_Wire_start_extend") != OK:
		printerr("Canvas: Failed to connect signal.")
	if new_wire.connect("end_extend", self, "_on_Wire_end_extend") != OK:
		printerr("Canvas: Failed to connect signal.")
	if new_wire.connect("drag_dir", self, "_on_Wire_drag_dir") != OK:
		printerr("Canvas: Failed to connect signal.")
	
	print_debug("Canvas: Ended new wire")


func create_savdata() -> Dictionary:
	var result = circuit_chip_spec.make_solution_template()
	
	for input in input_container.get_children():
		result["inputs"][input.input_name] = (
			CanvasInfo.pos_to_arr(input.position))
			
	for output in output_container.get_children():
		result["outputs"][output.output_name] = (
			CanvasInfo.pos_to_arr(output.position))
	
	for chip in chip_container.get_children():
		result["chips"].append({
			"type" : chip.chip_type,
			"pos"  : CanvasInfo.pos_to_arr(chip.position)
		})
	
	for wire in wire_container.get_children():
		result["wires"].append(wire.get_segments())
	
	print(result)
	
	return result


func _on_Wire_start_extend(wire):
	print_debug("Canvas: Start wire extension")
	is_extend_wire = true
	extending_wire = wire
	wire_preview.start_pos = mouse_pos
	wire_preview.show()


func _on_Wire_end_extend():
	wire_preview.hide()
	is_extend_wire = false
	extending_wire = null
	print_debug("Canvas: End wire extension")


func _on_Wire_drag_dir(is_vert: bool):
	wire_preview.is_vert = is_vert


func remove() -> void:
	queue_free()


func _next_chip_id() -> int:
	_last_chip_id += 1
	return _last_chip_id


func _next_wire_id() -> int:
	_last_wire_id += 1
	return _last_wire_id


func _on_SaveButton_pressed() -> void:
	emit_signal("save_requested", create_savdata())


func _on_ColorPickerButton_toggled(button_pressed) -> void:
	if button_pressed:
		color_picker.show()
		CanvasInfo.entities_hovered += 1
	else:
		color_picker.hide()
		CanvasInfo.entities_hovered -= 1


func _on_ColorPicker_color_changed(color) -> void:
	new_wire_color = color


func _on_SaveButton_mouse_entered() -> void:
	CanvasInfo.entities_hovered += 1


func _on_SaveButton_mouse_exited() -> void:
	CanvasInfo.entities_hovered -= 1


func _on_ColorPickerButton_mouse_entered() -> void:
	CanvasInfo.entities_hovered += 1


func _on_ColorPickerButton_mouse_exited() -> void:
	CanvasInfo.entities_hovered -= 1
