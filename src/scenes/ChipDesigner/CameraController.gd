extends Camera2D

# Current zoom level
var zoom_cur := 1.0

# Minimum zoom level
var zoom_min := 0.1

# Maximum zoom level
var zoom_max := 2.0

# Zoom increment
var zoom_inc := 0.1

# Whether the camera is being dragged
var is_dragged := false

# Previous mouse position
var prev_mouse_position := Vector2()

func _ready():
	zoom = Vector2(zoom_cur, zoom_cur)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_zoom_in"):
		zoom_cur = max(zoom_min, zoom_cur - zoom_inc)
		zoom = Vector2(zoom_cur, zoom_cur)
	elif event.is_action("ui_zoom_out"):
		zoom_cur = min(zoom_max, zoom_cur + zoom_inc)
		zoom = Vector2(zoom_cur, zoom_cur)
	elif event.is_action_pressed("ui_drag_camera"):
		prev_mouse_position = event.position
		is_dragged = true
	elif event.is_action_released("ui_drag_camera"):
		prev_mouse_position = Vector2()
		is_dragged = false
	elif is_dragged and event is InputEventMouseMotion:
		position -= event.position - prev_mouse_position
		prev_mouse_position = event.position
