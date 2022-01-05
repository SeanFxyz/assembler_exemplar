extends Area2D

# Where to implement inputs
const snap_inc := CanvasInfo.grid_inc

export var chip_type := ""
var chip_id : int
var input_nodes   := {}
var input_states  := {}
var output_nodes  := {}

var prev_mouse_position := Vector2()
var is_dragged := false

onready var sprite_rect : Rect2  = $Sprite.get_rect()

var input_name : String = "in" setget set_input_name

var input_state : int = 0
var input_width : int = 1

onready var outputs : Node2D = $Outputs
onready var label : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if (connect("input_event", self, "_on_input_event")         != OK or
			connect("mouse_entered", self, "_on_mouse_entered") != OK or
			connect("mouse_exited", self, "_on_mouse_exited")   != OK):
		printerr("CanvasChip: failed to connect signal")
	
	
	for output in outputs.get_children():
		output.chip = self
		output_nodes[output.output_name] = output
	
	label.text = input_state_to_string(input_state)


func _on_input_event(_viewport, event, _shape_idx):
	# Allow dragging if user clicks CollisionShape2D
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		prev_mouse_position = event.position
		is_dragged = true
		CanvasInfo.chips_dragged += 1
	if event.is_action_pressed("ui_toggle"):
		get_tree().set_input_as_handled()
		increment_input_state()
		
		
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
		

func input_state_to_string(state: int) -> String:
	return str(state)


func set_input_name(new_value: String) -> void:
	input_name = new_value


func set_input_state(_input_name: String, new_value: int) -> void:
	input_state = new_value
	label.text = input_state_to_string(input_state)
	update_outputs()


func increment_input_state() -> void:
	set_input_state("", (input_state + 1) % int(pow(2, input_width)))


func update_outputs() -> void:
	var owire := get_output_wire("out")
	if owire:
		owire.wire_state = input_state
	print_debug("CircuitInput: updating wire state: ", owire)


func get_output_wire(output_name: String) -> Node2D:
	var overlaps : Array = output_nodes[output_name].get_overlapping_areas()
	if overlaps.size() > 0:
		return overlaps[0].wire
	else:
		return null
