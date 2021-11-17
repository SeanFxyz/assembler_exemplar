extends Node2D

const Segment: PackedScene=preload("res://scenes/ChipDesigner/Wires/Wires.tscn")

var seg_grid := {}

onready var segments : Node2D = $Segments


func _ready():
	pass


func init_segment(pos: GridPos) -> Node2D:
	var new_seg : Node2D = Segment.instance()

	new_seg.grid_pos = pos
	seg_grid[pos.to_key()] = new_seg

	new_seg.connect("extend_wire", self, "_on_segment_extend_wire")
	new_seg.connect("delete", self, "_on_segment_delete")

	return new_seg


func add_seg_at_mouse() -> void:
	var mouse_pos : Vector2 = get_local_mouse_position()

	var grid_pos := GridPos.new(int(mouse_pos.x / CanvasInfo.grid_inc),
								int(mouse_pos.y / CanvasInfo.grid_inc))

	var new_seg : Node2D = init_segment(grid_pos)

	new_seg.is_dragged = true

	segments.add_child(new_seg)


func update_seg_shape(segment):
	var neighbors : Dictionary = segment.grid_pos.get_neighbors()
	if seg_grid.has(neighbors["left"].to_key()):
		segment.left = true
	if seg_grid.has(neighbors["right"].to_key()):
		segment.right = true
	if seg_grid.has(neighbors["up"].to_key()):
		segment.up = true
	if seg_grid.has(neighbors["down"].to_key()):
		segment.down = true


func update_neighbor_segs(pos: GridPos):
	for npos in pos.get_neighbors():
		var npos_key : int = npos.to_key()
		if seg_grid.has(npos_key):
			update_seg_shape(seg_grid[npos_key])


func _on_segment_extend_wire(pos: GridPos):
	print("Wire: extend wire")
	var cur_mouse_pos := get_local_mouse_position()


func _on_segment_delete(pos: GridPos):
	print("Wire: delete segment")
	var pos_key = pos.to_key()
	seg_grid[pos_key].queue_free()
	seg_grid.erase(pos_key)
	update_neighbor_segs(pos)
