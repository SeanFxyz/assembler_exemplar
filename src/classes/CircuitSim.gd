class_name CircuitSim


var input_names  : Array setget set_input_names
var output_names : Array setget set_output_names

var input_states  : Array setget set_input_states
var output_states : Array setget ,get_output_states

# An Array of Dictionaries representing the components of the circuit.
# Each component Dictionary will be of the Component class.
var components : Array

# A 2D array representing the truth table for comparison testing.
var truth_table : Array


func set_input_names(new_value: Array) -> void:
	input_names = new_value
	update_state()


func set_output_names(new_value: Array) -> void:
	output_names = new_value


func set_input_states(new_value: Array) -> void:
	input_states = new_value
	update_state()
	

func get_output_states() -> Array:
	return output_states


# Represents a component chip in the circuit.
class Component:
	var chip_id         : int
	var chip_type       : String
	var chip_spec       : ChipSpec
	
	# Array of dictionaries. Each dictionary has key `input`, mapped to a chip
	# input name, and key `pin`, mapped to a Pin
	var in_connections  : Array
	
	# Array of dictionaries. Each dictionary has key `output`, mapped to a chip
	# input name, and key `pin`, mapped to a Pin
	var out_connections : Array
	
	func _init(
		_chip_type       : String,
		_in_connections  : Array,
		_out_connections : Array
	):
		chip_type = _chip_type
		chip_spec = ChipIO.chip_specs[chip_type]
		in_connections = _in_connections
		out_connections = _out_connections
		

func update_state() -> void:
	
	# Find all chips connected to circuit inputs.
	for c in components:
		pass
