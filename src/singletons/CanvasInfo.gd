extends Node

# Grid square size
const grid_inc : int = 10

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
