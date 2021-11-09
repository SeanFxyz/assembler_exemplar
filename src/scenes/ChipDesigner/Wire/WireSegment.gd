extends Sprite

onready var modulator : CanvasModulate = $CanvasModulate

enum SegSprite {
	ALL = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3,
	DOWN = 4,
	LEFT_RIGHT = 5,
	UP_DOWN = 6
}

func set_color(color: Color):
	modulator.color = color
