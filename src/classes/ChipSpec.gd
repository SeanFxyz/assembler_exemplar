class_name ChipSpec


var input_names   : Array
var input_widths  : Dictionary
var output_names  : Array
var output_widths : Dictionary
var io            : Dictionary
var input_sets    : Array
var canvas_width  : int
var components    : Array


func _init(
	inames   : Array,
	iwidths  : Dictionary,
	onames   : Array,
	owidths  : Dictionary,
	i        : Dictionary,
	isets    : Array,
	canvas_w : int = 50,
	comp     : Array = ["Nand"]
):
	input_names = inames
	input_widths = iwidths
	output_names = onames
	output_widths = owidths
	io = i
	input_sets = isets
	canvas_width = canvas_w
	components = comp


func get_outputs(input_states: Dictionary) -> Dictionary:
	return io[format_input(input_states)]


# Takes an array of integer input values and combines them into a dictionary
# lookup key.
func format_input(input_states: Dictionary):
	var key : int = input_states[input_names[0]]
	for iname in input_names.slice(1, -1):
		key = key << input_widths[iname] | input_states[iname]
	
	return key


func make_solution_template() -> Dictionary:
	var template := {
		"inputs": {},
		"outputs": {},
		"chips": [],
		"wires": [],
		"score": 0,
	}
	
	var io_y    := 1
	var io_size : int = CanvasInfo.io_size
	
	for name in input_names:
		template["inputs"][name] = [1, io_y]
		io_y += io_size + 1
	
	io_y = 1
	
	for name in output_names:
		template["outputs"][name] = [canvas_width, io_y]
		io_y += io_size + 1
	
	return template
