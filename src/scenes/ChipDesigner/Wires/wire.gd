extends Line2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("input_event", self, "_on_Drag")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")

var prev_mouse_position = Vector2()
var end_mouse_position
var new_line = Line2D
var is_dragged = false

func _on_mouse_entered(event):
	prev_mouse_position = add_point(get_local_mouse_position(), 0)

func _on_Drag(event):
	is_dragged = true
	end_mouse_position = get_local_mouse_position()

func _on_mouse_exited(event):
	is_dragged = false
	new_line = add_point(get_local_mouse_position(), 1)
