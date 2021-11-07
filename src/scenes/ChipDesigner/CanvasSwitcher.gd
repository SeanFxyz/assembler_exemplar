extends Tabs

var Canvas:PackedScene=preload("res://scenes/ChipDesigner/Canvas/Canvas.tscn")

var add_pos := 0
var canvas_tabs := {}

func _ready():
	add_tab("+")
	connect("tab_clicked", self, "_on_tab_clicked")	


func _on_tab_clicked(tab: int):
	add_canvas(PlayerData.new_solution_name())


func add_canvas(name: String):
	add_tab(name)
	var tab_c := get_tab_count()
	add_pos = tab_c - 1
	move_tab(add_pos, add_pos - 1)
	
	var canvas : ViewportContainer = Canvas.instance()
	canvas_tabs[add_pos - 1] = canvas
	
	pass
