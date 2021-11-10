extends Area2D

# Where to implement inputs
var snap_inc = 10

export var chip_type := ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("input_event", self, "_on_Drag")

var prev_mouse_position = Vector2()
var is_dragged = false

func _on_Drag(_viewport, event, _shape_idx):
	
	
	# Allow dragging if user clicks CollisionShape2D
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		prev_mouse_position = event.position
		is_dragged = true
		CanvasInfo.chips_dragged += 1
		
func _input(event):
	# Disable dragging if click is released
	if not is_dragged:
		return
	
	if event.is_action_released("ui_select"):
		prev_mouse_position = Vector2()
		is_dragged = false
		CanvasInfo.chips_dragged -= 1
		# Snap to grid
		position = position.snapped(Vector2(snap_inc, snap_inc))
	
	if is_dragged and event is InputEventMouseMotion:
		position += (event.position - prev_mouse_position) * CanvasInfo.zoom_cur
		prev_mouse_position = event.position
