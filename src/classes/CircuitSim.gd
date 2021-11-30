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



		

func update_state() -> void:
	
	# Find all chips connected to circuit inputs.
	for c in components:
		pass
