extends TabContainer

# Maps tab/solution names to tab indices
var canvas_tabs := {}

func add_canvas_tab(name: String, canvas: Control) -> void:
	add_child(canvas)
	canvas.solution = name
	var tab_idx := get_tab_count() - 1
	canvas_tabs[name] = tab_idx
	current_tab = tab_idx


func remove_canvas_tab(name: String) -> void:
	get_tab_control(canvas_tabs[name]).remove()


func select_canvas_tab(name: String) -> void:
	get_current_tab_control().enabled = false
	current_tab = canvas_tabs[name]
	get_current_tab_control().enabled = true
