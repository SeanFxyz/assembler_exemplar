extends Control

onready var canvas_switcher := $CanvasSwitcher
onready var item_selected = false
onready var mouse_moved_to_canvas = false
onready var selected_item

func _on_ItemList_item_selected(index):
	print("item clicked")
	item_selected = true
	selected_item = $ItemListControl/ItemList.get_item_text(index)
	print(selected_item)

func _on_ItemList_nothing_selected():
	print("nothing selected")
	item_selected = false
	
func _on_ItemList_mouse_exited():
	print("exiting control node housing ItemList")
	if (item_selected == true):
		print("Moving " + selected_item + " to screen")
