extends Button

# Simple wrapper around Button that allows the button to signal what level it
# should launch.

signal level_button_pressed(level)

export var level : String

func _on_pressed() -> void:
	emit_signal("level_button_pressed", level)
