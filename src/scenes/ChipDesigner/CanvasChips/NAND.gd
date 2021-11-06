extends Area2D

# Where to implement inputs
var inputs = {
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var prev_mouse_position = Vector2()
var is_dragged = false

func _on_Drag(_viewport, event, _shape_idx):
	# Allow dragging if user clicks CollisionShape2D
	if event.is_action_pressed("ui_select"):
		print(event)
		get_tree().set_input_as_handled()
		prev_mouse_position = event.position
		is_dragged = true
		
func _input(event):
	# Disable dragging if click is released
	if not is_dragged:
		return
	
	if event.is_action_released("ui_select"):
		prev_mouse_position = Vector2()
		is_dragged = false
	
	if is_dragged and event is InputEventMouseMotion:
		position += event.position - prev_mouse_position
		prev_mouse_position = event.position