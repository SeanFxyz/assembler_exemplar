extends Control

onready var chip_info_panel = $LeftPanels/ChipInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = ""
	level = PlayerData.current_level
	
	var file = File.new()
	var file_name = "res://wiki/chips/" + level.to_lower() + ".md"
	assert(file.open(file_name, File.READ) == OK)
	var content = file.get_as_text()
	file.close()
	chip_info_panel.set_text(content)
