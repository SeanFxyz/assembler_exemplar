extends Node


func _ready():
	for level_button in get_tree().get_nodes_in_group("level_button"):
		level_button.connect(
			"level_button_pressed", self, "_on_level_button_pressed")


func _on_level_button_pressed(level: String):
	PlayerData.set_current_level(level)
	assert(get_tree().change_scene(
		"res://scenes/ChipDesigner/ChipDesigner.tscn") == OK)


func _on_BackButton_pressed():
	assert(get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn") == OK)
