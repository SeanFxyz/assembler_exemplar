extends ItemList

onready var level = PlayerData.current_level

func _ready():
	if level == "Not":
		# Only enable Nand gate
		# Mux
		remove_item(5)
		# Xor
		remove_item(4)
		# Or
		remove_item(3)
		# And
		remove_item(2)
		# Not
		remove_item(1)
	elif level == "And":
		# Enable Nand and Not
		remove_item(5)
		remove_item(4)
		remove_item(3)
		remove_item(2)
	elif level == "Or":
		# Enable Nand, Not, and And
		remove_item(5)
		remove_item(4)
		remove_item(3)
	elif level == "Xor":
		# Enable Nand, Not, And, and Or
		remove_item(5)
		remove_item(4)
	elif level == "Mux":
		# Enable Nand, Not, And, Or, and Xor
		remove_item(5)
	elif level == "DMux":
		print("test")
