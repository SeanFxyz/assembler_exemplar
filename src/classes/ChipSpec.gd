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
