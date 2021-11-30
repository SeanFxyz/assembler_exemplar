extends CanvasChip

export var output_name : String setget set_output_name

var input_state : int

onready var label : Label = .get_node("Label")

func _ready() -> void:
	._ready()
	label.text = output_name


func set_output_name(new_value: String) -> void:
	output_name = new_value
	label.text = output_name


func set_input_state(input_name: String, new_value: int) -> void:
	input_state = new_value
	label.text = input_state_to_string(input_state)
