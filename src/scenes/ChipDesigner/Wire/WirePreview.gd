extends Node2D

export var color : Color

var is_vert : bool = false

onready var _label := $Label


func _process(_delta):
	update()


func _draw():
	var start_gridpos := GridPos.new().from_vector2(position).to_vector2()
	var mouse_pos := get_local_mouse_position()
	var mouse_gridpos := GridPos.new().from_vector2(mouse_pos).to_vector2()
	
	var grid_offset := Vector2(CanvasInfo.grid_inc, CanvasInfo.grid_inc) / 2
	
	if start_gridpos.x == mouse_gridpos.x or start_gridpos.y == mouse_gridpos.y:
		var rect_pos : Vector2 = start_gridpos - grid_offset
		var size : Vector2 = mouse_gridpos + grid_offset - rect_pos
		draw_rect(Rect2(rect_pos, size), color)
	else:
		var p1 : Vector2 = start_gridpos - grid_offset
		var p2 : Vector2
		if is_vert:
			p2 = Vector2(start_gridpos.x, mouse_gridpos.y - start_gridpos.y)
		else:
			p2 = Vector2(mouse_gridpos.x - start_gridpos.x, start_gridpos.y)
		
		var s1 := p2 + grid_offset - p1
		var s2 := (mouse_gridpos + grid_offset) - (p2 - grid_offset)
		
		draw_rect(Rect2(p1, s1), color)
		draw_rect(Rect2(p2 - grid_offset, s2), color)
