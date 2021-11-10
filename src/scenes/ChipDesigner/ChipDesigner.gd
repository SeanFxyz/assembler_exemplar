extends Control

onready var canvas_switcher := $CanvasSwitcher
onready var current_canvas := $Canvas
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

func _on_Canvas_mouse_on():
	if item_selected == true:
		current_canvas.add_chip(selected_item)
	pass # Replace with function body.
