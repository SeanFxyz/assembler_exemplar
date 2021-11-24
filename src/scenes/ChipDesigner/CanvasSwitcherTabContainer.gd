extends TabContainer

# Maps tab/solution names to tab indices
var canvas_tabs := {}

func add_canvas_tab(name: String, canvas: Control):
	add_child(canvas)
	var tab_idx := get_tab_count() - 1
	canvas_tabs[name] = tab_idx
	current_tab = tab_idx


func remove_canvas_tab(name: String):
	get_tab_control(canvas_tabs[name]).remove()


func select_canvas_tab(name: String):
	current_tab = canvas_tabs[name]
