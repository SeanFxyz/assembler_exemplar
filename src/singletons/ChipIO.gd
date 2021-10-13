extends Node

var nand := {
	0b00: [1],
	0b01: [1],
	0b10: [1],
	0b11: [0],
}

# Find chip dictionaries by name
var chips := {
	"nand": nand,
}

func find_chip(name: String) -> Dictionary:
	return chips[name.to_lower()]
