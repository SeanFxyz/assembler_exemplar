extends Node2D

export var lower_x_bound = -10000
export var upper_x_bound = 10000
export var lower_y_bound = -10000
export var upper_y_bound = 10000 
export var snap_inc = 10
export var grid_line_color = Color(.5, .5, .5, 1)
#onready var view_rect = get_viewport().get_visible_rect()

func _draw():
	var i = lower_x_bound
	while(i <= upper_x_bound):
		draw_line(Vector2(i, lower_y_bound),
				  Vector2(i, upper_y_bound),
				  grid_line_color)
		i += snap_inc
	i = lower_y_bound
	while(i <= upper_y_bound):
		draw_line(Vector2(lower_x_bound, i),
				  Vector2(upper_x_bound, i),
				  grid_line_color)
		i += snap_inc

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
