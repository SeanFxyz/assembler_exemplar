extends Area2D

class_name CanvasChip

# Where to implement inputs
const snap_inc := CanvasInfo.grid_inc

export var chip_type := ""
var chip_id : int
var input_nodes   := {}
var input_states  := {}
var output_nodes  := {}

var prev_mouse_position := Vector2()
var is_dragged := false

onready var inputs      : Node2D = $Inputs
onready var outputs     : Node2D = $Outputs
onready var chip_spec   : ChipSpec = ChipIO.chip_specs[chip_type]
onready var sprite_rect : Rect2  = $Sprite.get_rect()


# Called when the node enters the scene tree for the first time.
func _ready():
	if (connect("input_event", self, "_on_input_event") != OK or
			connect("mouse_entered", self, "_on_mouse_entered") != OK or
			connect("mouse_exited", self, "_on_mouse_exited") != OK):
		printerr("CanvasChip: failed to connect signal")
	
	for input in inputs.get_children():
		input.chip = self
		input_nodes[input.input_name] = input
		input_states[input.input_name] = 0
	for output in outputs.get_children():
		output.chip = self
		output_nodes[output.output_name] = output


func _on_input_event(_viewport, event, _shape_idx):
	# Allow dragging if user clicks CollisionShape2D
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		prev_mouse_position = event.position
		is_dragged = true
		CanvasInfo.chips_dragged += 1
		
		
func _on_mouse_entered():
	CanvasInfo.entities_hovered += 1


func _on_mouse_exited():
	CanvasInfo.entities_hovered -= 1
		
		
func _input(event):
	# Disable dragging if click is released
	if not is_dragged:
		return
	
	if event.is_action_released("ui_select"):
		prev_mouse_position = Vector2()
		is_dragged = false
		CanvasInfo.chips_dragged -= 1
		# Snap to grid
		position = position.snapped(Vector2(snap_inc, snap_inc))
	
	if is_dragged and event is InputEventMouseMotion:
		position += (event.position - prev_mouse_position) * CanvasInfo.zoom_cur
		prev_mouse_position = event.position


func set_input_state(input_name: String, state: int) -> void:
	print_debug("CanvasChip: setting input state ", input_name, " to ", state)
	input_states[input_name] = state
	update_outputs()


func get_input_wire(input_name: String) -> Node2D:
	var overlaps : Array = input_nodes[input_name].get_overlapping_areas()
	if overlaps.size() > 0:
		return overlaps[0].wire
	else:
		return null


func get_output_wire(output_name: String) -> Node2D:
	var overlaps : Array = output_nodes[output_name].get_overlapping_areas()
	if overlaps.size() > 0:
		return overlaps[0].wire
	else:
		return null
		

func input_state_to_string(state: int) -> String:
	return str(state)


func update_outputs() -> void:
	var output_states : Dictionary = (
		chip_spec.io[chip_spec.format_input(input_states)])
	
	for oname in output_states.keys():
		var owire := get_output_wire(oname)
		if owire:
			owire.wire_state = output_states[oname]
