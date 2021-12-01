extends Control

onready var chip_info_panel = $LeftPanels/ChipInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	var level = ""
	level = PlayerData.current_level
	# DEBUG
	print(level)
	
	var file = File.new()
	var file_name = "res://wiki/chips/" + level.to_lower() + ".md"
	# DEBUG
	print(file_name)
	file.open(file_name, File.READ)
	var content = file.get_as_text()
	file.close()
	chip_info_panel.set_text(content)
