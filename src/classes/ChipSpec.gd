class_name ChipSpec

var input_names   : Array
var input_widths  : Array
var output_names  : Array
var output_widths : Array
var io            : Dictionary

func _init(
	inames  : Array,
	iwidths : Array,
	onames  : Array,
	owidths : Array,
	i       : Dictionary
):
	input_names = inames
	input_widths = iwidths
	output_names = onames
	output_widths = owidths
	io = i


# Takes an array of integer input values and combines them into a dictionary
# lookup key.
func format_input(input_states: Array):
	var key : int = input_states[0]
	for i in range(len(input_widths) - 1):
		key = key << input_widths[i] | input_widths[i + 1]
	return key


func make_solution_template() -> Dictionary:
	var template := {
		"inputs": {},
		"outputs": {},
		"chips": {},
		"wires": {},
		"score": {},
	}
	
	var io_y    := 1
	var io_size : int = CanvasInfo.io_size
	
	for name in input_names:
		template["inputs"][name] = [1, io_y]
		io_size += io_size + 1
	
	io_y = 1
	
	for name in output_names:
		template["outputs"][name] = [CanvasInfo.circuit_width, io_y]
		io_y += io_size + 1
	
	return template
