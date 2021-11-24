extends Node2D

signal start_extend
signal end_extend
signal drag_dir(is_vert)

const Segment: PackedScene=preload("res://scenes/ChipDesigner/Wire/WireSegment.tscn")


var is_extend       : bool    = false
var drag_is_vert    : int     = false
var drag_start      : Vector2


func add_segment_path(start: Vector2, end: Vector2, is_vert: bool) -> void:
	var s1_end : Vector2
	if is_vert:
		s1_end = Vector2(start.x, end.y)
	else:
		s1_end = Vector2(end.x, start.y)
	
	add_segment(start, s1_end)
	
	if s1_end != end:
		add_segment(s1_end, end)


func add_segment(start: Vector2, end: Vector2) -> void:
	var new_seg = Segment.instance()
	new_seg.start = GridPos.new().from_pos(start)
	new_seg.end   = GridPos.new().from_pos(end)
	
	new_seg.connect("seg_input", self, "_on_seg_input")
	
	add_child(new_seg)
	print_debug("Wire: added segment: ", new_seg.start, ", ", new_seg.end)


func _on_seg_input(seg: CollisionObject2D, event: InputEvent) -> void:
	if   event.is_action_pressed("ui_select"):
		start_extend()
	elif event.is_action_pressed("ui_delete"):
		seg.remove()
	elif event is InputEventMouseMotion and is_drag_moved():
		fix_drag_dir()


func is_drag_moved() -> bool:
	if is_extend and CanvasInfo.snap(get_local_mouse_position()) != drag_start:
		return true
	else:
		return false


func start_extend() -> void:
	emit_signal("start_extend")
	
	drag_is_vert = false
	
	drag_start = CanvasInfo.snap(get_local_mouse_position())
	

func fix_drag_dir() -> void:
	var snapped_mouse_pos := CanvasInfo.snap(get_local_mouse_position())
	
	if snapped_mouse_pos.x != drag_start.x:
		drag_is_vert = false
		emit_signal("drag_dir", false)
	elif snapped_mouse_pos.y != drag_start.y:
		drag_is_vert = true
		emit_signal("drag_dir", true)
	

func end_extend() -> void:
	#TODO: add new segment(s)
	add_segment_path(drag_start, get_local_mouse_position(), drag_is_vert)
	
	emit_signal("end_extend")
