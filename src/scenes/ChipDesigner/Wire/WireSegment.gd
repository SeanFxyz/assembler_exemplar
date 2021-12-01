extends Area2D

signal seg_input(seg, event)
signal seg_update(seg_id, rect)

const state_rect_margin : int = -1 * (CanvasInfo.grid_inc / 2)

var seg_id       : int = 0

# The wire the segment belongs to, unique within the Canvas
var wire         : Node2D
var wire_id      : int

var wire_state   : int     = false

var start        : GridPos = GridPos.new(5, 8) setget set_start
var end          : GridPos = GridPos.new(5, 5) setget set_end
var is_dragged   : bool
var highlighted  : bool    = false             setget set_highlighted
var hovered      : bool    = false
var rect         : Rect2   = Rect2()
var color        : Color   = Color.red

onready var collider := $CollisionShape2D

func _ready() -> void:
	update_seg()


func update_seg() -> void:
	
	var start_offset := Vector2()
	var end_offset   := Vector2()
	if end.x >= start.x:
		start_offset.x = 0
		end_offset.x   = CanvasInfo.grid_inc
	else:
		start_offset.x = CanvasInfo.grid_inc
		end_offset.x   = 0
	if end.y >= start.y:
		start_offset.y = 0
		end_offset.y   = CanvasInfo.grid_inc
	else:
		start_offset.y = CanvasInfo.grid_inc
		end_offset.y   = 0
	
	var rect_start := start.to_pos() + start_offset
	rect.position = rect_start
	rect.end      = end.to_pos() + end_offset
	
	
	# Not sure why, but using the `collider` variable initialized on ready
	# didn't seem to work here.
	var _collider : CollisionShape2D = $CollisionShape2D
	_collider.position = rect_start + rect.size / 2
	var new_collider_shape = RectangleShape2D.new()
	new_collider_shape.extents = rect.size.abs() / 2
	_collider.set_deferred("shape", new_collider_shape)
	
	emit_signal("seg_update", seg_id, rect)


func set_start(new_value: GridPos) -> void:
	if new_value.x != end.x and new_value.y != end.y:
		if start.x == end.x:
			# this is a vertical segment
			end.x = new_value.x
		elif start.y == end.y:
			# this is a horizontal segment
			end.y = new_value.y
	
	start = new_value
	update_seg()


func set_end(new_value: GridPos) -> void:
	if new_value.x != start.x and new_value.y != end.y:
		if start.x == end.x:
			# this is a vertical segment
			end.x = new_value.x
		elif start.y == end.y:
			# this is a horizontal segment
			end.y = new_value.y
			
	end = new_value
	update_seg()


func set_highlighted(new_value: bool):
	highlighted = new_value
	update_seg()


func remove():
	if hovered:
		CanvasInfo.entities_hovered -= 1
	queue_free()


func get_overlapping_chip_inputs() -> Array:
	# TODO: re-write to use collision mask instead
	var result := []
	
	for a in get_overlapping_areas():
		if a.is_in_group("chip_input"):
			result.append(a)

	return result


func get_overlapping_chip_outputs() -> Array:
	# TODO: re-write to use collision mask instead
	var result := []
	
	for a in get_overlapping_areas():
		if a.is_in_group("chip_output"):
			result.append(a)
	
	return result


#func _draw():
#	draw_rect(rect, color)
#
#	if wire_state > 0:
#		var state_rect := rect.abs().grow(-3)
#		draw_rect(state_rect, color.lightened(30))


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		print("WireSegment: clicked")
	emit_signal("seg_input", self, event)


func _on_mouse_entered():
	CanvasInfo.entities_hovered += 1
	hovered = true


func _on_mouse_exited():
	CanvasInfo.entities_hovered -= 1
	hovered = false


func _on_wire_state_changed(state: bool):
	wire_state = state
	update_seg()
