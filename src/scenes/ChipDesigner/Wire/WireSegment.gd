extends Node2D

onready var sprite : AnimatedSprite = $AnimatedSprite

var is_dragged : bool
var grid_pos   : GridPos setget set_grid_pos

signal extend_wire(x, y)


func set_shape(shape: int):
	sprite.frame = shape


func set_grid_pos(new_value: GridPos):
	grid_pos = new_value
	position.x = grid_pos.x
	position.y = grid_pos.y
	position *= CanvasInfo.grid_inc


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_select"):
		get_tree().set_input_as_handled()
		is_dragged = true


func _on_mouse_entered():
	CanvasInfo.entities_hovered += 1


func _on_mouse_exited():
	CanvasInfo.entities_hovered -= 1
	if is_dragged:
		print("Segment: extend wire")
		emit_signal("extend_wire", grid_pos)
		is_dragged = false
