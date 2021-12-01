extends Area2D

export var output_name : String

var chip : Area2D


func _on_mouse_entered():
	CanvasInfo.chip_io_hovered += 1


func _on_mouse_exited():
	CanvasInfo.chip_io_hovered -= 1
