extends CanvasChip

export var input_name : String setget set_input_name

var input_state : int

onready var label : Label = .get_node("Label")

func _ready() -> void:
	._ready()
	label.text = input_name


func set_input_name(new_value: String) -> void:
	input_name = new_value
	label.text = input_name


func set_input_state(input_name: String, new_value: int) -> void:
	input_state = new_value
	update_output()


func update_output() -> void:
	var out_wire := get_output_wire("out")
	if out_wire:
		out_wire.wire_state = input_state
