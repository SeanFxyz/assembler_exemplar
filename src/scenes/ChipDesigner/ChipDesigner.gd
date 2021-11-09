extends Control

onready var canvas_switcher := $CanvasSwitcher

func _on_ItemList_item_selected(index):
	print("item clicked")
	pass # Replace with function body.


func _on_ItemList_nothing_selected():
	print("nothing selected")
	pass # Replace with function body.
