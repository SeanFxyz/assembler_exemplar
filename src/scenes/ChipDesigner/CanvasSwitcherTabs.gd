extends Tabs

signal add_tab_selected
signal canvas_tab_selected

var add_pos := 0

# Maps tab/solution names to tab indices
var canvas_tabs := {}

func _ready():
	add_tab("+")
	connect("tab_changed", self, "_on_tab_changed")	


func _on_tab_changed(tab: int):
	if tab == add_pos:
		emit_signal("add_tab_selected")
	else:
		emit_signal("canvas_tab_selected", get_tab_title(tab))


# Adds a canvas tab with the given name
func add_canvas_tab(name: String) -> void:
	add_tab(name)
	var tab_c := get_tab_count()
	var new_tab_pos := tab_c - 2
	
	move_tab(add_pos, add_pos - 1)
	canvas_tabs[name] = add_pos - 1
	
	add_pos = tab_c - 1
	current_tab = add_pos - 1


# Removes a canvas tab with the given name
func del_canvas_tab(name: String) -> void:
	remove_tab(canvas_tabs[name])
	add_pos -= 1


# Switches to the canvas tab with the given name
func change_canvas_tab(name: String) -> void:
	current_tab = canvas_tabs[name]
