extends Node

# Grid square size
const grid_inc : int = 10

# Grid snap vector
const grid_snap : Vector2 = Vector2(grid_inc, grid_inc)

# Grid center offset vector
const center_offset : Vector2 = grid_snap / 2

# Highlight color
const highlight_color : Color = Color.whitesmoke

# How many chips are being dragged
var chips_dragged : int = 0

# How many entities the mouse is touching
var entities_hovered : int = 0

# Current zoom level
var zoom_cur : float = 1.0

# Minimum zoom level
var zoom_min : float = .5

# Maximum zoom level
var zoom_max : float = 5.0

# Zoom increment
var zoom_inc : float = 0.1

# Snap a position Vector2 to the canvas grid
func snap(v: Vector2) -> Vector2:
	return (v / grid_inc).floor() * grid_inc

# Snap a position Vector2 to the center of its grid square.
func snap_center(v: Vector2) -> Vector2:
	return snap(v) + center_offset


var wire_colors := []
var wire_color_index := 0

func init_wire_colors():
	pass


func next_wire_color():
	pass
