class_name CircuitComponent

# Represents a component chip in a circuit simulation

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
