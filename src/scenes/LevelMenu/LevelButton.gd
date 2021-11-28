tool
extends Button

# Simple wrapper around Button that allows the button to signal what level it
# should launch.

signal level_button_pressed(level)

export var level : String = "Nand" setget set_level

func set_level(new_value):
	text = new_value

func _on_pressed():
	emit_signal("level_button_pressed", level)
