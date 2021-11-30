class_name CircuitCompiler

# Compiles CanvasChip and Wire nodes into a simulation representation

# Dictionary mapping chip_type strings to the last ID number used for the
# chip types
var last_chip_id  : Dictionary

var last_wire_id  : int

var chip_nodes    : Array
var wire_nodes    : Array


func _init(_chip_nodes:=[], _wire_nodes:=[]):
	last_chip_id = {}
	last_wire_id = -1
	chip_nodes = _chip_nodes
	wire_nodes = _wire_nodes


func next_chip_id(chip_type: String) -> String:
	if last_chip_id.has(chip_type):
		last_chip_id[chip_type] += 1
		return chip_type + str(last_chip_id[chip_type])
	else:
		last_chip_id[chip_type] = 0
		return chip_type + "0"


func next_wire_id() -> int:
	last_wire_id += 1
	return last_wire_id


func compile() -> CircuitSim:
	var circuit_sim : CircuitSim
	
	var components := {}
	
	for chip in chip_nodes:
		var ct : String = chip.chip_type
		if ct == "in":
			pass
		elif ct == "out":
			pass
		else:
			components[next_chip_id(ct)] = chip.to_circuit_component()

	return circuit_sim
