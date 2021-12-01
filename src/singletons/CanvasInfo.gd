extends Node

# Circuit input/output size (radius) in grid squares
const io_size : int = 10

# Grid square size
const grid_inc : int = 10

# Grid snap vector
const grid_snap : Vector2 = Vector2(grid_inc, grid_inc)

# Offset from the corner to the center of a grid square.
const center_offset : Vector2 = grid_snap / 2

# Highlight color
const highlight_color : Color = Color.whitesmoke

enum {
	CLAYER_CANVASCHIP = 0,
	CLAYER_CHIPINPUT  = 1,
	CLAYER_CHIPOUTPUT = 2,
	CLAYER_WIRE       = 3,
}

# How many chips are being dragged
var chips_dragged : int = 0

# TODO: use signalling between entities and the specific Canvas, rather than
# the entities_hovered and chip_io_hovered variables.

# How many entities the mouse is touching
var entities_hovered : int = 0

# How many ChipInput or ChipOutput nodes is the mouse touching
var chip_io_hovered  : int = 0

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


# Convert an array describing a position in the canvas grid to a world position
func arr_to_pos(a: Array) -> Vector2:
	return Vector2(a[0], a[1]) * grid_inc


# Convert a world position to an array describing the position in the canvas
# grid
func pos_to_arr(v: Vector2) -> Array:
	var snapped = CanvasInfo.snap(v) / grid_inc
	return [snapped.x, snapped.y]


var wire_colors := []
var wire_color_index := 0

func init_wire_colors():
	pass


func next_wire_color():
	pass
