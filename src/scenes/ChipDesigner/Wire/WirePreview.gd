extends Node2D

export var color : Color

var is_vert : bool = false
var start_pos : Vector2 setget set_start_pos


func set_start_pos(new_value: Vector2) -> void:
	start_pos = CanvasInfo.snap_center(new_value)


func _ready():
	set_start_pos(Vector2(400, 400))


func _process(_delta):
	update()


func _draw():
	var mouse_pos := CanvasInfo.snap_center(get_local_mouse_position())
	
	var grid_offset := CanvasInfo.grid_snap / 2
	
	if start_pos.x == mouse_pos.x or start_pos.y == mouse_pos.y:
		var rect_pos : Vector2 = start_pos - grid_offset
		var size : Vector2 = mouse_pos + grid_offset - rect_pos
		draw_rect(Rect2(rect_pos, size), color)
	else:
		var p1 : Vector2 = start_pos - grid_offset
		var p2 : Vector2
		if is_vert:
			p2 = Vector2(start_pos.x, mouse_pos.y)
		else:
			p2 = Vector2(mouse_pos.x, start_pos.y)
		
		var s1 := p2 + grid_offset - p1
		var s2 := (mouse_pos + grid_offset) - (p2 - grid_offset)
		
		draw_rect(Rect2(p1, s1), color)
		draw_rect(Rect2(p2 - grid_offset, s2), color)
