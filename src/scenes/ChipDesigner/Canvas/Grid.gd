extends Node2D

export var lower_y_bound = -10000
export var lower_x_bound = -10000
export var upper_x_bound = 10000
export var upper_y_bound = 10000 
export var snap_inc = 50
export var grid_line_color = Color(.5, .5, .5, 1)
onready var view_rect = get_viewport().get_visible_rect()

func _draw():
	for i in range(lower_y_bound, upper_y_bound, snap_inc):
		draw_line(Vector2(lower_x_bound, lower_y_bound + i),
				  Vector2(upper_x_bound, lower_y_bound + i),
				  grid_line_color)
	for i in range(lower_x_bound, upper_x_bound, snap_inc):
		draw_line(Vector2(lower_x_bound + i, lower_y_bound),
				  Vector2(lower_x_bound + i, upper_y_bound),
				  grid_line_color)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
