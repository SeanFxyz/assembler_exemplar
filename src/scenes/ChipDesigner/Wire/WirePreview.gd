extends Node2D

export var color : Color

var is_vert : bool = true # should the first segment of the path be vertical?
var start_pos : Vector2 setget set_start_pos


func _ready():
	set_start_pos(Vector2(50, 50))


func set_start_pos(new_value: Vector2) -> void:
	start_pos = CanvasInfo.snap(new_value)


func _process(_delta):
	update()


func _draw():
	var mouse_pos := CanvasInfo.snap(get_global_mouse_position())
	
	if is_vert:
		var p2 := Vector2(start_pos.x, mouse_pos.y)
		draw_preview(start_pos, p2)
		if p2 != mouse_pos:
			p2.x += sign(mouse_pos.x - p2.x) * CanvasInfo.grid_inc
			draw_preview(p2, mouse_pos)
	
	else:
		var p2 := Vector2(mouse_pos.x, start_pos.y)
		draw_preview(start_pos, p2)
		if p2 != mouse_pos:
			p2.y += sign(mouse_pos.y - p2.y) * CanvasInfo.grid_inc
			draw_preview(p2, mouse_pos)
		

func draw_preview(start: Vector2, end: Vector2):
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
	
	var rect_start := start + start_offset
	var rect_size  := (end + end_offset) - rect_start
	
	draw_rect(Rect2(rect_start, rect_size), color)
