# The `ChipIO` Singleton include pre-populated dictionaries mapping chip
# inputs to the corresponding outputs, which is used by nodes to
# simulate player-created chips and verify them during testing.
# Since more than one part of the program needs to know the correct output of
# a chip given a particular input, this singleton centralizes that
# functionality.

extends Node

# Chip name: Nand
# Inputs:    a, b
# Outputs:   out
# Function:  If a=b=1 then out=0 else out=1
# Comment:   The gate is considered primitive and thus there is
#            no need to implement it [in-game].
var Nand := {
	0b00: { "out": 1 },
	0b01: { "out": 1 },
	0b10: { "out": 1 },
	0b11: { "out": 0 },
}

# Chip name: Not
# Inputs:    in
# Outputs:   out
# Function:  If in=0 then out=1 else out=0.
var Not := {
	0b0: { "out": 1 },
	0b1: { "out": 0 },
}

# Chip name: And
# Inputs:    a, b
# Outputs:   out
# Function:  If a=b=1 then out=1 else out=0.
var And := {
	0b00: { "out": 0 },
	0b01: { "out": 0 },
	0b10: { "out": 0 },
	0b11: { "out": 1 },
}

# Chip name: Or
# Inputs:    a, b
# Outputs:   out
# Function:  If a=b=0 then out=0 else out=1.
var Or := {
	0b00: { "out": 0 },
	0b01: { "out": 1 },
	0b10: { "out": 1 },
	0b11: { "out": 1 },
}

# Chip name: Xor
# Inputs:    a, b
# Outputs:   out
# Function:  If a!=b then out=1 else out=0.
var Xor := {
	0b00: { "out": 0 },
	0b01: { "out": 1 },
	0b10: { "out": 1 },
	0b11: { "out": 0 },
}

# Chip name: Mux
# Inputs:    a, b, sel
# Outputs:   out
# Function:  If sel=0 then out=a else out=b.
var Mux := {
	0b000: { "out": 0 },
	0b010: { "out": 0 },
	0b100: { "out": 1 },
	0b110: { "out": 1 },
	0b001: { "out": 0 },
	0b011: { "out": 1 },
	0b101: { "out": 0 },
	0b111: { "out": 1 },
}

# Chip name: DMux
# Inputs:    in, sel
# Outputs:   a, b
# Function:  If sel=0 then {a=in, b=0} else {a=0, b=in}
var DMux := {
	0b00: { "a": 0, "b": 0 },
	0b01: { "a": 0, "b": 0 },
	0b10: { "a": 1, "b": 0 },
	0b11: { "a": 0, "b": 1 },
}


# Enables finding chip dictionaries by name.
var chips := {
	"nand": Nand,
	"not": Not,
	"and": And,
	"or": Or,
	"xor": Xor,
	"mux": Mux,
	"dmux": DMux,
}

# Find a chip I/O dictionary by name (case-insensitive)
func find_chip(name: String) -> Dictionary:
	return chips[name.to_lower()]