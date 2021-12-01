extends Node2D

signal start_extend
signal end_extend
signal drag_dir(is_vert)

signal wire_state_changed(state)

const Segment: PackedScene=preload("res://scenes/ChipDesigner/Wire/WireSegment.tscn")

# Wire ID, unique within the Canvas
var wire_id      : int
var wire_state   : int     = 0 setget set_wire_state
var color        : Color   = Color.green

# Indicates whether the user is dragging the mouse to *extend* the wire.
var is_extend    : bool    = false

# Indicates whether the mouse drag to extend the wire started with a vertical
# motion.
var drag_is_vert : int     = false

# The start position of the mouse drag to extend the wire.
var drag_start   : Vector2

onready var segments : Node2D  = $Segments


#func _ready() -> void:
	#add_segment(Vector2(50, 50), Vector2(50, 100))


func set_wire_state(new_value: int) -> void:
	wire_state = new_value
	emit_signal("wire_state_changed", wire_state)
	update_connected_inputs()


func update_connected_inputs():
	for input in get_connected_chip_inputs():
		input.chip.set_input_state(input.input_name, wire_state)


func get_connected_chip_io() -> Array:
	var result := []
	
	for seg in segments.get_children():
		result.append_array(seg.get_overlapping_areas())
	
	return result


func get_connected_chip_inputs() -> Array:
	var result := []
	
	for seg in segments.get_children():
		result.append_array(seg.get_overlapping_chip_inputs())
	
	return result


func get_connected_chip_outputs() -> Array:
	var result := []
	
	for seg in segments.get_children():
		result.append_array(seg.get_overlapping_chip_outputs())
	
	return result
	

# Add one or two segments to the wire as needed to get from `start` to `end`.
# `is_vert` determines whether the *first* segment will be vertical (true) or
# horizontal (false).
func add_segment_path(start: Vector2, end: Vector2, is_vert: bool) -> void:
	var s1_end : Vector2
	if is_vert:
		s1_end = Vector2(start.x, end.y)
	else:
		s1_end = Vector2(end.x, start.y)
	
	add_segment(start, s1_end)
	
	if s1_end != end:
		add_segment(s1_end, end)


# Adds a segment to this wire from the given start point to the given end point.
# The start and end are in world-space coordinates within the Canvas, but
# will be snapped to the grid.
# TODO: figure out how to merge segments that are parallel and end-to-end
func add_segment(start: Vector2, end: Vector2) -> void:
	var new_seg = Segment.instance()
	new_seg.start = GridPos.new().from_pos(start)
	new_seg.end   = GridPos.new().from_pos(end)
	
	if(connect("wire_state_changed", new_seg, "_on_wire_state_changed") != OK or
			new_seg.connect("seg_input", self, "_on_seg_input")         != OK or
			new_seg.connect("area_entered",self,"_on_seg_area_entered") != OK or
			new_seg.connect("area_exited", self, "_on_seg_area_exited") != OK):
		printerr("Wire: failed to connect signal")
	
	new_seg.color = color
	
	new_seg.wire_id = wire_id
	new_seg.wire = self
	new_seg.wire_state = wire_state
	
	segments.add_child(new_seg)


# Remove the specified segment from the wire
func remove_segment(seg: CollisionObject2D):
	seg.remove()
	if segments.get_children().size() <= 0:
		queue_free()


func get_segments() -> Array:
	var result := []
	for seg in segments.get_children():
		result.append([
			seg.start.to_array(),
			seg.end.to_array(),
		])
	return result


# Triggers when a connected WireSegment emits the "seg_input" signal,
# indicating that its "input_event" signal has been emitted.
# `seg` is the segment that emitted the signal.
# `event` is the InputEvent that triggered the signal.
func _on_seg_input(seg: CollisionObject2D, event: InputEvent) -> void:
	if   event.is_action_pressed("ui_select"):
		start_extend()
	elif event.is_action_pressed("ui_delete"):
		remove_segment(seg)
		queue_free()
	elif event is InputEventMouseMotion and is_drag_moved():
		fix_drag_dir()


# Test whether the mouse has moved away from the drag start position.
func is_drag_moved() -> bool:
	if is_extend and CanvasInfo.snap(get_local_mouse_position()) != drag_start:
		return true
	else:
		return false


# Start extending this wire.
func start_extend() -> void:
	emit_signal("start_extend", self)
	is_extend = true
	drag_start = CanvasInfo.snap(get_local_mouse_position())
	

# Detect which directionality (horizontal or vertical) the user's mouse has
# taken, correct the drag_is_vert variable accordingly, and emit the "drag_dir"
# signal to tell the Canvas what we have corrected it too.
func fix_drag_dir() -> void:
	var snapped_mouse_pos := CanvasInfo.snap(get_local_mouse_position())
	
	if snapped_mouse_pos.x != drag_start.x:
		drag_is_vert = false
		emit_signal("drag_dir", false)
	elif snapped_mouse_pos.y != drag_start.y:
		drag_is_vert = true
		emit_signal("drag_dir", true)
	

# End the extension of this wire.
func end_extend() -> void:
	add_segment_path(drag_start, get_local_mouse_position(), drag_is_vert)
	emit_signal("end_extend")
	is_extend = false


func _on_seg_area_entered(area: Area2D) -> void:
	update_connected_inputs()


func _on_seg_area_exited(area: Area2D) -> void:
	update_connected_inputs()
