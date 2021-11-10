extends Camera2D

signal zoom_factor_changed(new_zoom_factor)

# Whether the camera is being dragged
var is_dragged := false

# Previous mouse position
var prev_mouse_position := Vector2()

func _ready():
	zoom = Vector2(CanvasInfo.zoom_cur, CanvasInfo.zoom_cur)

func _input(event: InputEvent) -> void:
	if (event is InputEventMouse and
			get_viewport_rect().has_point(event.position)):
		
		if event.is_action("ui_zoom_in"):
			CanvasInfo.zoom_cur = max(CanvasInfo.zoom_min,
									  CanvasInfo.zoom_cur - CanvasInfo.zoom_inc)
			zoom = Vector2(CanvasInfo.zoom_cur, CanvasInfo.zoom_cur)
		elif event.is_action("ui_zoom_out"):
			CanvasInfo.zoom_cur = min(CanvasInfo.zoom_max,
									  CanvasInfo.zoom_cur + CanvasInfo.zoom_inc)
			zoom = Vector2(CanvasInfo.zoom_cur, CanvasInfo.zoom_cur)
		elif event.is_action_pressed("ui_drag_camera"):
			prev_mouse_position = event.position
			is_dragged = true
		elif event.is_action_released("ui_drag_camera"):
			prev_mouse_position = Vector2()
			is_dragged = false
		elif is_dragged and event is InputEventMouseMotion:
			position -= event.position - prev_mouse_position
			prev_mouse_position = event.position
