extends Node2D

signal seg_input(seg, event)

var start        : GridPos = GridPos.new(5, 8) setget set_start
var end          : GridPos = GridPos.new(5, 5) setget set_end
var is_dragged   : bool
var highlighted  : bool    = false             setget set_highlighted
var rect         : Rect2   = Rect2()

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
	_collider.shape = RectangleShape2D.new()
	_collider.shape.extents = rect.size.abs() / 2
	
	update()


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
	queue_free()


func _draw():
	draw_rect(rect, modulate)
	
	if highlighted:
		draw_rect(rect, CanvasInfo.highlight_color, false, 1.0)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		print("WireSegment: clicked")
	emit_signal("seg_input", self, event)
