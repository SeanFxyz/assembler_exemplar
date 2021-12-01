extends ColorPicker

var default : Color = Color.green

export(Array, Color) var presets := [
	Color.red,
	Color.orangered,
	Color.orange,
	Color.yellow,
	Color.yellowgreen,
	Color.green,
	Color.cyan,
	Color.blue,
	Color.blueviolet,
]


func _ready():
	for p in presets:
		add_preset(p)
