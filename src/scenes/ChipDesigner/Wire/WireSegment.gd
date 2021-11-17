extends Node2D

onready var sprite : AnimatedSprite = $AnimatedSprite
var texture := preload("res://images/WireTiles/all.png")

var is_dragged   : bool
var is_extending : bool
var start_pos    : GridPos = GridPos.new(0, 0) # setget set_start_pos
var end_pos      : GridPos = GridPos.new(0, 5) # setget set_end_pos
var is_vert      : bool

signal extend_wire(x, y)


func set_start_pos(new_value) -> void:
	if is_vert:
		end_pos.x = new_value.x
	else:
		end_pos.y = new_value.y
	
	start_pos = new_value
	
	update()


func set_end_pos(new_value) -> void:
	if is_vert:
		start_pos.x = new_value.x
	else:
		end_pos.y = new_value.y
	
	end_pos = new_value
	
	update()


func _draw():
	if is_vert:
		var x     := start_pos.x
		var start := start_pos.y
		var end   := end_pos.y
		for y in range(start, end + 1):
			draw_texture(texture, Vector2(x, y) * CanvasInfo.grid_inc)
	else:
		var y     := start_pos.y
		var start := start_pos.x
		var end   := end_pos.y
		for x in range(start, end + 1):
			draw_texture(texture, Vector2(x, y) * CanvasInfo.grid_inc)
			
	
