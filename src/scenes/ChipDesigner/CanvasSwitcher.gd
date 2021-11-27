extends Control

signal canvas_switched(canvas)

var Canvas:PackedScene=preload("res://scenes/ChipDesigner/Canvas/Canvas.tscn")

var solution_canvases := {}

onready var tabs := $Tabs
onready var tab_container := $TabContainer

	
func get_current_canvas() -> Control:
	return tab_container.get_current_tab_control()


func _on_add_tab_selected() -> void:
	var new_solution_name := PlayerData.create_solution()
	PlayerData.current_solution = new_solution_name
	
	tabs.add_canvas_tab(new_solution_name)
	
	var new_canvas = Canvas.instance()
	tab_container.add_canvas_tab(new_solution_name, new_canvas)
	
	emit_signal("canvas_switched", new_canvas)


func _on_canvas_tab_selected(name: String) -> void:
	tab_container.select_canvas_tab(name)
