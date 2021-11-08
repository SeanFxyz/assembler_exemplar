extends Node2D

export var snap_inc = 50
export var grid_line_color = Color(.5, .5, .5, 1)
onready var view_rect = get_viewport().get_visible_rect()

func _draw():
	for i in range(view_rect.position.y, view_rect.end.y, snap_inc):
		draw_line(Vector2(view_rect.position.x, view_rect.position.y + i),
				  Vector2(view_rect.end.x, view_rect.position.y + i),
				  grid_line_color)
	for i in range(view_rect.position.x, view_rect.end.x, snap_inc):
		draw_line(Vector2(view_rect.position.x + i, view_rect.position.y),
				  Vector2(view_rect.position.x + i, view_rect.end.y),
				  grid_line_color)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
